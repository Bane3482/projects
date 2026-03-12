#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define IMAGE_DOS_SIGNATURE 0x5A4D
#define IMAGE_NT_SIGNATURE  0x00004550

int read_data(FILE* f, uint64_t addr, char* buf, uint32_t size) {
    if (fseek(f, addr, SEEK_CUR) != 0
        || fread(buf, 1, size, f) != size
        || fseek(f, -(addr + size), SEEK_CUR) != 0) {
        return 1;
    }
    return 0;
}

int is_pe(const char *filepath) {
    FILE *f = fopen(filepath, "rb");
    if (!f) {
        return 1;
    }

    uint16_t dos_sign;
    if (read_data(f, 0, (char*)&dos_sign, sizeof(dos_sign)) != 0
        || dos_sign != IMAGE_DOS_SIGNATURE) {
        fclose(f);
        return 1;
    }

    uint32_t pe_addr;
    if (read_data(f, 0x3C, (char*)&pe_addr, sizeof(pe_addr)) != 0
        || fseek(f, pe_addr, SEEK_SET) != 0) {
        fclose(f);
        return 1;
    }

    uint32_t pe_sign;
    if (fread(&pe_sign, 1, sizeof(pe_sign), f) != sizeof(pe_sign)
        || pe_sign != IMAGE_NT_SIGNATURE) {
        fclose(f);
        return 1;
    }
    return 0;
}

int print_string(FILE *f) {
    char c;
    while (fread(&c, 1, 1, f) == 1 && c != '\0') {
        printf("%c", c);
    }
    printf("\n");
    return 0;
}

int import_functions(const char *filepath) {
    FILE *f = fopen(filepath, "rb");
    if (!f) {
        return 1;
    }

    uint32_t pe_addr;
    if (read_data(f, 0x3C, (char*)&pe_addr, sizeof(pe_addr)) != 0
        || fseek(f, pe_addr + 24, SEEK_SET) != 0) {
        fclose(f);
        return 1;
    }

    uint32_t import_table_rva;
    if (read_data(f, 0x78, (char*)&import_table_rva, sizeof(import_table_rva)) != 0
        || fseek(f, 240, SEEK_CUR) != 0) {
        fclose(f);
        return 1;
    }

    uint32_t section_virtual_size;
    uint32_t section_rva;
    uint32_t section_raw;
    do {
        if (read_data(f, 0x8, (char*)&section_virtual_size, sizeof(section_virtual_size)) != 0
            || read_data(f, 0xC, (char*)&section_rva, sizeof(section_rva)) != 0
            || read_data(f, 0x14, (char*)&section_raw, sizeof(section_raw)) != 0
            || fseek(f, 40, SEEK_CUR) != 0) {
            fclose(f);
            return 1;
        }
    } while(import_table_rva < section_rva || import_table_rva > section_rva + section_virtual_size);

    uint32_t import_raw = section_raw + (import_table_rva - section_rva);
    while (1) {
        if (fseek(f, import_raw, SEEK_SET) != 0) {
            fclose(f);
            return 1;
        }
        char dependence[20];
        if (fread(dependence, 1, 20, f) != 20) {
            fclose(f);
            return 1;
        }

        if (memcmp(dependence, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 20) == 0) {
            break;
        }

        uint32_t lib_rva;
        memcpy(&lib_rva, dependence + 0xC, 4);

        uint32_t lib_addr = section_raw + lib_rva - section_rva;
        if (fseek(f, lib_addr, SEEK_SET) != 0) {
            fclose(f);
            return 1;
        }

        if (print_string(f) != 0) {
            fclose(f);
            return 1;
        }

        uint32_t lookup_rva;
        memcpy(&lookup_rva, dependence, 4);

        uint32_t lookup_addr = section_raw + lookup_rva - section_rva;
        while (1) {
            if (fseek(f, lookup_addr, SEEK_SET) != 0) {
                fclose(f);
                return 1;
            }
            
            uint64_t field;
            if (fread(&field, 1, 8, f) != 8) {
                fclose(f);
                return 1;
            }

            if (field == 0) {
                break;
            }
            
            if ((field & (1ULL << 63)) != 0) {
                lookup_addr += 8;
                continue;
            }

            uint32_t name_rva = field & ((1u << 31) - 1);
            uint32_t name_addr = section_raw + name_rva - section_rva + 2;

            if (fseek(f, name_addr, SEEK_SET) != 0) {
                fclose(f);
                return 1;
            }

            printf("    ");
            if (print_string(f) != 0) {
                fclose(f);
                return 1;
            }
            lookup_addr += 8;
        }
        import_raw += 20;
    }
    return 0;
}

int main(int argc, char **argv) {
    if (argc != 3) {
        printf("Error argument count\n");
        return -1;
    }
    if (strcmp(argv[1], "is-pe") == 0) {
        int result = is_pe(argv[2]);
        if (result == 0) {
            printf("PE\n");
        }  else if (result == 1) {
            printf("Not PE\n");
        }
        return result;
    } else if (strcmp(argv[1], "import-functions") == 0) {
        return import_functions(argv[2]);
    }
    printf("Incorrect operation name: %s", argv[1]);
    return 0;
}
