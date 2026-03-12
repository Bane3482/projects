#include <cstdio>
#include <cstring>
#include <memory>

static size_t findEqual(int* p, const char* str, size_t cur, char symbol) {
  while (cur != 0 && symbol != str[cur]) {
    cur = p[cur - 1];
  }
  return cur;
}

static int* prefix_function(const char* str, const size_t n) {
  int* p = static_cast<int*>(malloc(n * sizeof(int)));
  if (p == nullptr) {
    return p;
  }
  p[0] = 0;
  for (size_t i = 1; i < n; i++) {
    size_t cur = p[i - 1];
    cur = findEqual(p, str, cur, str[i]);
    p[i] = (str[i] == str[cur]) ? cur + 1 : 0;
  }
  return p;
}

int main(int argc, char** argv) {
  if (argc != 3) {
    fprintf(stderr, "Usage %s arguments: expected 2 arguments(File name, string), found %d\n", argv[0], argc - 1);
    return EXIT_FAILURE;
  }
  const char* str = argv[2];
  const size_t n = strlen(str);
  if (n == 0) {
    puts("Yes");
    return 0;
  }
  const char* file_name = argv[1];
  FILE* file = fopen(file_name, "rb");
  if (file == nullptr) {
    fprintf(stderr, "File opening failed: %s\n", file_name);
    return EXIT_FAILURE;
  }
  int* p = prefix_function(str, n);
  if (p == nullptr) {
    fprintf(stderr, "No prefix function, malloc failed\n");
    fclose(file);
    return EXIT_FAILURE;
  }
  int c;
  size_t ptr = 0;
  while ((c = fgetc(file)) != EOF && ptr != n) {
    auto u_symbol = static_cast<unsigned char>(c);
    char symbol = static_cast<char>(u_symbol);
    ptr = findEqual(p, str, ptr, symbol);
    if (str[ptr] == symbol) {
      ptr++;
    }
  }
  int result = 0;
  if (ferror(file) != 0) {
    fprintf(stderr, "Error while reading from file '%s'\n", file_name);
    result = EXIT_FAILURE;
  } else {
    puts((ptr == n ? "Yes" : "No"));
  }
  free(p);
  fclose(file);
  return result;
}
