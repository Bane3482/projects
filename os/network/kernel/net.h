//
// endianness support
//

#include "types.h"

static inline uint16 bswaps(uint16 val) {
  return (((val & 0x00ffU) << 8) | ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val) {
  return (((val & 0x000000ffUL) << 24) | ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) | ((val & 0xff000000UL) >> 24));
}

// Use these macros to convert network bytes to the native byte order.
// Note that Risc-V uses little endian while network order is big endian.
#define ntohs bswaps
#define ntohl bswapl
#define htons bswaps
#define htonl bswapl

//
// useful networking headers
//

#define ETHADDR_LEN 6

// an Ethernet packet header (start of the packet).
struct eth {
  uint8 dhost[ETHADDR_LEN];
  uint8 shost[ETHADDR_LEN];
  uint16 type;
} __attribute__((packed));

#define ETHTYPE_IP 0x0800   // Internet protocol
#define ETHTYPE_ARP 0x0806  // Address resolution protocol

// an IP packet header (comes after an Ethernet header).
struct ip {
  uint8 ip_vhl;   // version << 4 | header length >> 2
  uint8 ip_tos;   // type of service
  uint16 ip_len;  // total length, including this IP header
  uint16 ip_id;   // identification
  uint16 ip_off;  // fragment offset field
  uint8 ip_ttl;   // time to live
  uint8 ip_p;     // protocol
  uint16 ip_sum;  // checksum, covers just IP header
  uint32 ip_src, ip_dst;
};

struct IPv4_header {

    // версия IP (4 для IPv4)
    uint8 version : 4;

    // IHL (длина заголовка в 32-бит словах)
    uint8 IHL : 4;

    // Type of Service 
    // (приоритет, задержка, пропускная способность, надежность)
    uint8 ToS;

    // Общая длина пакета (IP заголовок + транспортный заголовок + данные) в байтах     
    uint16 total_length;

    // Уникальный ID фрагмента для сборки фрагментированных пакетов
    uint16 identification;

    // Флаги фрагментации
    uint8 flags : 3;

    // Смещение фрагмента -- позиция фрагмента в исходном пакете
    uint16 frag_offset : 13;
    
    // Time To Live - счетчик промежуточных узлов
    uint8 TTL;           

    // Протокол верхнего уровня (6=TCP, 17=UDP, 1=ICMP, 2=IGMP)
    uint8 protocol;    
    
    // Контрольная сумма только IP-заголовка
    uint16 checksum;       

    // IP-адрес источника
    uint32 source;

    // IP-адрес назначения
    uint32 destination;

    // Дополнительные параметры 
    uint8 options[0];
};

struct IPv6_header {
    // версия IP (6 для IPv6)
    uint8 version : 4;

    // Traffic Class -- класс трафика, аналогия ToS в IPv4 
    uint8 TC : 8;

    // Flow Label -- Метка потока для маркировки пакетов одного потока
    uint32 FL : 20;

    // Длина полезной нагрузки (без заголовка)
    uint16 payload_length;  
    
    // Следующий заголовок (тип расширения или протокол)
    uint8 next_header;
    
    // Предел переходов (аналог TTL)
    uint8 hop_limit;           
    
    // IP-адрес источника
    uint8 source[4];

    // IP-адрес назначения
    uint8 destination[4];
};

struct TCP_pseudo_header_IPv4 {
    // IPv4-адрес отправителя
    uint32 src_addr;           
    
    // IPv4-адрес получателя
    uint32 dst_addr;           
    
    // Зарезервировано (должен быть занулены)
    uint8 reserved;            
    
    // Протокол (для TCP = 6)
    uint8 protocol;            
    
    // Длина TCP-сегмента (заголовок + данные)
    uint16 tcp_length;         
};

struct TCP_pseudo_header_IPv6 {
    // IPv6-адрес отправителя
    uint8 src_addr[16];

    // IPv6-адрес получателя
    uint8 dst_addr[16];        

    // Длина TCP-сегмента (заголовок + данные)
    uint32 tcp_length;         

    // Зарезервировано (3 байта, должны быть занулены)
    uint8 reserved[3];         

    // Следующий заголовок (для TCP = 6)
    uint8 next_header;         
};

struct TCP_header {
    // Исходный порт
    uint16 src_port;

    // Порт назначения
    uint16 dst_port;

    // Номер последовательности - порядковый номер первого байта данных в сегменте
    uint32 seq_num;

    // Номер подтверждения - следующий ожидаемый байт при установленном флаге ACK
    uint32 ack_num;

    // Смещение данных
    uint16 data_offset : 4;    

    // Зарезервировано
    uint16 reserved : 6;
       
    // Флаги (6 бит): URG|ACK|PSH|RST|SYN|FIN
    uint16 flags : 6;         

    // Размер окна приема (16 бит) - сколько байт получатель готов принять
    uint16 window;

    // Контрольная сумма (псевдозаголовок IP + TCP заголовок + данные)
    uint16 checksum;

    // Указатель срочности - offset от seq_num до конца срочных данных (если URG=1)
    uint16 urgent_ptr;
    
    // Опции (переменной длины), всегда кратны 8 битам
    uint8 options[0];       
}

#define IPPROTO_ICMP 1  // Control message protocol
#define IPPROTO_TCP 6   // Transmission control protocol
#define IPPROTO_UDP 17  // User datagram protocol

#define MAKE_IP_ADDR(a, b, c, d) \
  (((uint32)a << 24) | ((uint32)b << 16) | ((uint32)c << 8) | (uint32)d)

// a UDP packet header (comes after an IP header).
struct udp {
  uint16 sport;  // source port
  uint16 dport;  // destination port
  uint16 ulen;   // length, including udp header, not including IP header
  uint16 sum;    // checksum
};

// an ARP packet (comes after an Ethernet header).
struct arp {
  uint16 hrd;  // format of hardware address
  uint16 pro;  // format of protocol address
  uint8 hln;   // length of hardware address
  uint8 pln;   // length of protocol address
  uint16 op;   // operation

  char sha[ETHADDR_LEN];  // sender hardware address
  uint32 sip;             // sender IP address
  char tha[ETHADDR_LEN];  // target hardware address
  uint32 tip;             // target IP address
} __attribute__((packed));

#define ARP_HRD_ETHER 1  // Ethernet

enum {
  ARP_OP_REQUEST = 1,  // requests hw addr given protocol addr
  ARP_OP_REPLY = 2,    // replies with the hw addr of the protocol addr
};

// an DNS packet (comes after an UDP header).
struct dns {
  uint16 id;  // request ID

  uint8 rd : 1;  // recursion desired
  uint8 tc : 1;  // truncated
  uint8 aa : 1;  // authoritive
  uint8 opcode : 4;
  uint8 qr : 1;     // query/response
  uint8 rcode : 4;  // response code
  uint8 cd : 1;     // checking disabled
  uint8 ad : 1;     // authenticated data
  uint8 z : 1;
  uint8 ra : 1;  // recursion available

  uint16 qdcount;  // number of question entries
  uint16 ancount;  // number of resource records in answer section
  uint16 nscount;  // number of NS resource records in authority section
  uint16 arcount;  // number of resource records in additional records
} __attribute__((packed));

struct dns_question {
  uint16 qtype;
  uint16 qclass;
} __attribute__((packed));

#define ARECORD (0x0001)
#define QCLASS (0x0001)

struct dns_data {
  uint16 type;
  uint16 class;
  uint32 ttl;
  uint16 len;
} __attribute__((packed));

#define SNIFFER_PKT_HEADER (sizeof(uint) + sizeof(int))
#define SNIFFER_PKT_MAX_BUF (512 - SNIFFER_PKT_HEADER)
struct sniffer_record {
  uint timestamp;
  int size;
  char buf[SNIFFER_PKT_MAX_BUF];
} __attribute__((packed));
