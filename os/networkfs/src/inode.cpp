#include "inode.h"

#define FUSE_USE_VERSION 317

#include <dirent.h>
#include <fuse_lowlevel.h>

#include <algorithm>
#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <map>
#include <memory>
#include <new>
#include <string>
#include <vector>

#include "http.h"
#include "util.h"

#define BLK_SZ 512

char* token;

std::map<size_t, struct stat> stats;

struct file_buffer {
  char* data;
  size_t size;
};

void set_attr(int to_set, struct stat* st, struct stat* from) {
  if (to_set & FUSE_SET_ATTR_MODE) {
    st->st_mode = from->st_mode;
  }
  if (to_set & FUSE_SET_ATTR_UID) {
    st->st_uid = from->st_uid;
  }
  if (to_set & FUSE_SET_ATTR_GID) {
    st->st_gid = from->st_gid;
  }
  if (to_set & FUSE_SET_ATTR_SIZE) {
    st->st_size = from->st_size;
    st->st_blocks = (st->st_size + BLK_SZ - 1) / BLK_SZ;
  }
  if (to_set & FUSE_SET_ATTR_ATIME) {
    st->st_atime = from->st_atime;
  }
  if (to_set & FUSE_SET_ATTR_MTIME) {
    st->st_mtime = from->st_mtime;
  }
  if (to_set & FUSE_SET_ATTR_CTIME) {
    st->st_ctime = from->st_ctime;
  }
}

void set_base_attr(ino_t ino, unsigned char entry_type) {
  if (stats.find(ino) != stats.end()) {
    return;
  }

  stats[ino].st_ino = ino;
  struct stat* st = &stats[ino];

  st->st_uid = getuid();
  st->st_gid = getgid();
  st->st_mtime = time(NULL);
  st->st_ctime = time(NULL);
  st->st_blksize = 4096;
  st->st_rdev = 0;
  st->st_dev = 0;
  if (entry_type == DT_DIR) {
    st->st_mode = S_IFDIR | 0755;
    st->st_size = 4096;
    st->st_nlink = 2;
  } else {
    st->st_mode = S_IFREG | 0644;
    st->st_size = 0;
    st->st_nlink = 1;
  }
  st->st_blocks = (st->st_size + BLK_SZ - 1) / BLK_SZ;
}

int format_err(int res) {
  if (res < 0) {
    return -res;
  }

  switch (res) {
    case 1:
      return ENOENT;
    case 2:
      return EISDIR;
    case 3:
      return ENOTDIR;
    case 4:
      return ENOENT;
    case 5:
      return EEXIST;
    case 6:
      return EFBIG;
    case 7:
      return ENOSPC;
    case 8:
      return ENOTEMPTY;
    case 9:
      return ENAMETOOLONG;
    default:
      return 0;
  }
}

/// RESULT FORMATS ///////////////////////////////////////////

struct lookup_result {
  unsigned char entry_type;  // DT_DIR (4) or DT_REG (8)
  ino_t ino;
};

struct list_result {
  size_t entries_count;
  struct entry {
    unsigned char entry_type;  // DT_DIR (4) or DT_REG (8)
    ino_t ino;
    char name[256];
  } entries[16];
};

struct create_result {
  ino_t ino;
};

struct read_result {
  uint64_t content_length;
  char content[512];
};

//////////////////////////////////////////////////////////////

void networkfs_init(void* userdata, struct fuse_conn_info* conn) {
  token = (char*)userdata;

  set_base_attr(1, DT_DIR);
}

void networkfs_destroy(void* private_data) {
  // Token string, which was allocated in main.
  free(private_data);
}

void networkfs_lookup(fuse_req_t req, fuse_ino_t parent, const char* name) {
  char ino_str[21];
  ino_to_string(ino_str, parent);

  size_t buffer_size = sizeof(lookup_result);
  char* response_buffer = new char[buffer_size];

  std::vector<std::pair<std::string, std::string>> args = {{"parent", ino_str},
                                                           {"name", name}};

  int err =
      networkfs_http_call(token, "lookup", response_buffer, buffer_size, args);

  if ((err = format_err(err)) != 0) {
    delete[] response_buffer;
    fuse_reply_err(req, err);
    return;
  }

  lookup_result* result = (lookup_result*)response_buffer;

  if (result->ino == 1000) {
    result->ino = 1;
  }

  set_base_attr(result->ino, result->entry_type);

  struct fuse_entry_param e;
  e.ino = result->ino;
  e.generation = 0;
  e.attr = stats[e.ino];
  e.attr_timeout = 0.0;
  e.entry_timeout = 0.0;

  fuse_reply_entry(req, &e);
  delete[] response_buffer;
}

void networkfs_getattr(fuse_req_t req, fuse_ino_t ino,
                       struct fuse_file_info* fi) {
  if (stats.find(ino) != stats.end()) {
    fuse_reply_attr(req, &stats[ino], 0);
  } else {
    fuse_reply_err(req, ENOENT);
  }
}

void networkfs_iterate(fuse_req_t req, fuse_ino_t i_ino, size_t size, off_t off,
                       struct fuse_file_info* fi) {
  size_t buffer_size = sizeof(list_result);
  char* response_buffer = new char[buffer_size];

  char ino_str[21];
  ino_to_string(ino_str, i_ino);

  std::vector<std::pair<std::string, std::string>> args = {{"inode", ino_str}};
  int err =
      networkfs_http_call(token, "list", response_buffer, buffer_size, args);

  if ((err = format_err(err)) != 0) {
    delete[] response_buffer;
    fuse_reply_err(req, err);
    return;
  }

  list_result* result = (list_result*)response_buffer;

  char* buffer = new char[size];

  for (int i = 0; i < result->entries_count; i++) {
    if (result->entries[i].ino == 1000) {
      result->entries[i].ino = 1;
    }
  }

  size_t offset = 0;
  for (int i = off; i < result->entries_count; i++) {
    set_base_attr(result->entries[i].ino, result->entries[i].entry_type);
    size_t c = fuse_add_direntry(req, buffer + offset, size - offset,
                                 result->entries[i].name,
                                 &stats[result->entries[i].ino], i + 1);
    if (c == 0 || c > size - offset) {
      break;
    }
    offset += c;
  }

  fuse_reply_buf(req, buffer, offset);
  delete[] buffer;
  delete[] response_buffer;
}

void networkfs_create(fuse_req_t req, fuse_ino_t parent, const char* name,
                      mode_t mode, struct fuse_file_info* fi) {
  size_t buffer_size = sizeof(create_result);
  char* response_buffer = new char[buffer_size];

  char ino_str[21];
  ino_to_string(ino_str, parent);

  std::vector<std::pair<std::string, std::string>> args = {
      {"parent", ino_str}, {"name", name}, {"type", "file"}};

  int err =
      networkfs_http_call(token, "create", response_buffer, buffer_size, args);

  if ((err = format_err(err)) != 0) {
    delete[] response_buffer;
    fuse_reply_err(req, err);
    return;
  }

  create_result* result = (create_result*)response_buffer;

  if (result->ino == 1000) {
    result->ino = 1;
  }
  set_base_attr(result->ino, DT_REG);

  stats[result->ino].st_mode |= (mode & 0777);

  fuse_entry_param e;
  e.ino = result->ino;
  e.generation = 0;
  e.attr = stats[e.ino];
  e.entry_timeout = 0.0;
  e.attr_timeout = 0.0;

  struct file_buffer* file_buffer = new struct file_buffer();
  file_buffer->size = 0;
  file_buffer->data = nullptr;

  fi->fh = (uint64_t)file_buffer;

  fi->direct_io = 0;
  fi->nonseekable = 0;
  fi->keep_cache = 1;

  fuse_reply_create(req, &e, fi);
  delete[] response_buffer;
}

void networkfs_unlink(fuse_req_t req, fuse_ino_t parent, const char* name) {
  char ino_str[21];
  ino_to_string(ino_str, parent);

  std::vector<std::pair<std::string, std::string>> args = {{"parent", ino_str},
                                                           {"name", name}};

  size_t buffer_size = sizeof(lookup_result);
  char* response_buffer = new char[buffer_size];

  int err =
      networkfs_http_call(token, "lookup", response_buffer, buffer_size, args);

  if ((err = format_err(err)) != 0) {
    delete[] response_buffer;
    fuse_reply_err(req, err);
    return;
  }

  ino_t ino = ((lookup_result*)response_buffer)->ino;

  if (stats.find(ino) == stats.end()) {
    delete[] response_buffer;
    fuse_reply_err(req, ENOENT);
  }

  stats[ino].st_nlink--;

  err = networkfs_http_call(token, "unlink", nullptr, 0, args);

  if ((err = format_err(err)) != 0) {
    delete[] response_buffer;
    fuse_reply_err(req, err);
    return;
  }

  stats.erase(ino);

  fuse_reply_err(req, 0);
  delete[] response_buffer;
}

void networkfs_mkdir(fuse_req_t req, fuse_ino_t parent, const char* name,
                     mode_t mode) {
  char ino_str[21];
  ino_to_string(ino_str, parent);

  size_t buffer_size = sizeof(create_result);
  char* response_buffer = new char[buffer_size];

  std::vector<std::pair<std::string, std::string>> args = {
      {"parent", ino_str}, {"name", name}, {"type", "directory"}};

  int err =
      networkfs_http_call(token, "create", response_buffer, buffer_size, args);

  if ((err = format_err(err)) != 0) {
    delete[] response_buffer;
    fuse_reply_err(req, err);
    return;
  }

  create_result* result = (create_result*)response_buffer;

  if (result->ino == 1000) {
    result->ino = 1;
  }

  set_base_attr(result->ino, DT_DIR);

  stats[result->ino].st_mode |= (mode & 0777);

  fuse_entry_param e;
  e.ino = result->ino;
  e.generation = 0;
  e.attr = stats[e.ino];
  e.entry_timeout = 0.0;
  e.attr_timeout = 0.0;

  fuse_reply_entry(req, &e);
  delete[] response_buffer;
}

void networkfs_rmdir(fuse_req_t req, fuse_ino_t parent, const char* name) {
  char buf[21];

  ino_to_string(buf, parent);

  std::vector<std::pair<std::string, std::string>> args = {{"parent", buf},
                                                           {"name", name}};

  size_t buffer_size = sizeof(lookup_result);
  char* response_buffer = new char[buffer_size];

  int err =
      networkfs_http_call(token, "lookup", response_buffer, buffer_size, args);

  if ((err = format_err(err)) != 0) {
    delete[] response_buffer;
    fuse_reply_err(req, err);
    return;
  }

  ino_t ino = ((lookup_result*)response_buffer)->ino;

  stats.erase(ino);

  err = networkfs_http_call(token, "rmdir", nullptr, 0, args);

  if ((err = format_err(err)) != 0) {
    delete[] response_buffer;
    fuse_reply_err(req, err);
    return;
  }

  fuse_reply_err(req, 0);
  delete[] response_buffer;
}

void networkfs_open(fuse_req_t req, fuse_ino_t i_ino, fuse_file_info* fi) {
  if (fi == nullptr) {
    fuse_reply_err(req, EBADF);
    return;
  }

  struct file_buffer* file_buffer = new struct file_buffer();
  if ((fi->flags & O_RDONLY) ||
      (!(fi->flags & O_TRUNC) &&
       ((fi->flags & O_RDWR) || (fi->flags & O_WRONLY)))) {
    char ino_str[21];
    ino_to_string(ino_str, i_ino);

    std::vector<std::pair<std::string, std::string>> args = {
        {"inode", ino_str}};

    size_t buffer_size = sizeof(read_result);
    char* response_buffer = new char[buffer_size];

    int err =
        networkfs_http_call(token, "read", response_buffer, buffer_size, args);

    if ((err = format_err(err)) != 0) {
      delete[] response_buffer;
      delete file_buffer;
      fuse_reply_err(req, err);
      return;
    }

    read_result* result = (read_result*)response_buffer;

    file_buffer->size = result->content_length;
    file_buffer->data = new char[file_buffer->size];
    memcpy(file_buffer->data, result->content, file_buffer->size);
    delete[] response_buffer;
  } else if ((fi->flags & O_TRUNC) &&
             ((fi->flags & O_RDWR) || (fi->flags & O_WRONLY))) {
    file_buffer->size = 0;
    file_buffer->data = nullptr;
  } else {
    delete file_buffer;
    fuse_reply_err(req, EINVAL);
    return;
  }

  stats[i_ino].st_size = file_buffer->size;
  stats[i_ino].st_blocks = (file_buffer->size + BLK_SZ - 1) / BLK_SZ;

  fi->fh = (uint64_t)file_buffer;

  fi->direct_io = 0;
  fi->nonseekable = 0;
  fi->keep_cache = 1;

  fuse_reply_open(req, fi);
}

void networkfs_release(fuse_req_t req, fuse_ino_t ino,
                       struct fuse_file_info* fi) {
  if (fi && fi->fh) {
    struct file_buffer* file_buffer = (struct file_buffer*)fi->fh;
    fi->fh = 0;
    delete[] file_buffer->data;
    delete file_buffer;
  }
  fuse_reply_err(req, 0);
}

void networkfs_read(fuse_req_t req, fuse_ino_t ino, size_t size, off_t off,
                    struct fuse_file_info* fi) {
  if (fi == nullptr || fi->fh == 0) {
    fuse_reply_err(req, EBADF);
    return;
  }

  struct file_buffer* file_buffer = (struct file_buffer*)fi->fh;

  if (off >= file_buffer->size) {
    fuse_reply_buf(req, nullptr, 0);
    return;
  }

  fuse_reply_buf(req, file_buffer->data + off,
                 std::min(size, file_buffer->size - off));
}

void networkfs_write(fuse_req_t req, fuse_ino_t ino, const char* buffer,
                     size_t size, off_t off, struct fuse_file_info* fi) {
  if (fi == nullptr || fi->fh == 0) {
    fuse_reply_err(req, EIO);
    return;
  }

  struct file_buffer* file_buffer = (struct file_buffer*)fi->fh;

  if ((fi->flags & O_APPEND)) {
    off = file_buffer->size;
  }

  if (off + size > file_buffer->size) {
    char* new_buf = new char[off + size];
    memcpy(new_buf, file_buffer->data, file_buffer->size);
    delete[] file_buffer->data;
    file_buffer->size = off + size;
    file_buffer->data = new_buf;
  }

  memcpy(file_buffer->data + off, buffer, size);

  set_base_attr(ino, DT_REG);
  stats[ino].st_size = file_buffer->size;
  stats[ino].st_blocks = (file_buffer->size + BLK_SZ - 1) / BLK_SZ;

  fuse_reply_write(req, size);
}

void networkfs_flush(fuse_req_t req, fuse_ino_t ino,
                     struct fuse_file_info* fi) {
  if (fi == nullptr || fi->fh == 0 || (fi->flags & O_RDONLY)) {
    fuse_reply_err(req, 0);
    return;
  }

  char buf[21];

  ino_to_string(buf, ino);

  struct file_buffer* file_buffer = (struct file_buffer*)fi->fh;

  std::string content(file_buffer->data, file_buffer->size);

  std::vector<std::pair<std::string, std::string>> args = {
      {"inode", buf}, {"content", content}};

  int err = networkfs_http_call(token, "write", nullptr, 0, args);

  if ((err = format_err(err)) != 0) {
    fuse_reply_err(req, err);
    return;
  }

  fuse_reply_err(req, 0);
}

void networkfs_fsync(fuse_req_t req, fuse_ino_t ino, int datasync,
                     struct fuse_file_info* fi) {
  networkfs_flush(req, ino, fi);
}

void networkfs_setattr(fuse_req_t req, fuse_ino_t ino, struct stat* attr,
                       int to_set, struct fuse_file_info* fi) {
  if (fi == nullptr || fi->fh == 0) {
    fuse_reply_err(req, EBADF);
  }

  if (to_set & FUSE_SET_ATTR_SIZE) {
    struct file_buffer* file_buffer = (struct file_buffer*)fi->fh;
    if (file_buffer->size < attr->st_size) {
      char* new_buf = new char[attr->st_size];
      memcpy(new_buf, file_buffer->data, file_buffer->size);
      delete file_buffer->data;
      file_buffer->data = new_buf;

      char buf[21];

      ino_to_string(buf, ino);

      std::string content(new_buf, attr->st_size);

      std::vector<std::pair<std::string, std::string>> args = {
          {"inode", buf}, {"content", content}};

      int err = networkfs_http_call(token, "write", nullptr, 0, args);

      if ((err = format_err(err)) != 0) {
        fuse_reply_err(req, err);
        return;
      }
    }
    set_attr(to_set, &stats[ino], attr);
    file_buffer->size = stats[ino].st_size;
  }

  fuse_reply_attr(req, &stats[ino], 0);
}

void networkfs_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t newparent,
                    const char* name) {
  char buf1[21];

  ino_to_string(buf1, ino);

  char buf2[21];

  ino_to_string(buf2, newparent);

  std::vector<std::pair<std::string, std::string>> args = {
      {"source", buf1}, {"parent", buf2}, {"name", name}};

  int err = networkfs_http_call(token, "link", nullptr, 0, args);

  if ((err = format_err(err)) != 0) {
    fuse_reply_err(req, err);
    return;
  }

  set_base_attr(ino, DT_REG);

  stats[ino].st_nlink++;

  fuse_entry_param e;
  e.ino = ino;
  e.attr_timeout = 0.0;
  e.entry_timeout = 0.0;
  e.attr = stats[ino];
  fuse_reply_entry(req, &e);
}

void networkfs_forget(fuse_req_t req, fuse_ino_t ino, uint64_t nlookup) {
  fuse_reply_none(req);
}

const struct fuse_lowlevel_ops networkfs_oper = {
    .init = networkfs_init,
    .destroy = networkfs_destroy,
    .lookup = networkfs_lookup,
    .forget = networkfs_forget,
    .getattr = networkfs_getattr,
    .setattr = networkfs_setattr,
    .mkdir = networkfs_mkdir,
    .unlink = networkfs_unlink,
    .rmdir = networkfs_rmdir,
    .link = networkfs_link,
    .open = networkfs_open,
    .read = networkfs_read,
    .write = networkfs_write,
    .flush = networkfs_flush,
    .release = networkfs_release,
    .fsync = networkfs_fsync,
    .readdir = networkfs_iterate,
    .create = networkfs_create,
};