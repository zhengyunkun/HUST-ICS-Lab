#include <iostream>
#include <cstring>
#include <cstdio>
#

using namespace std;

//返回x的绝对值
int absVal(int x) {
  int mask = x >> 31;
  return (x ^ mask) - mask;
}

//不使用负号实现-x
int negate(int x) {
  return ~x + 1;
}

//仅使用 ~ 和 |，实现 &
int bitAnd(int x, int y) {
  return ~((~x) | (~y));
}

//仅使用 ~ 和 &，实现 ^
int bitOr(int x, int y) {
  return ~(~x & ~y);
}

// 仅使用 ~ 和 &，实现 ^
int bitXor(int x, int y) {
  return ~(~x & ~y) & ~(x & y);
}

//判断x是否为最大的正整数
int isTmax(int x) {
  return !(x + 1 + x + 1) & !!(x + 1);
}

//统计x的二进制表示中 1 的个数
int bitCount(int x) {
  x = x - ((x >> 1) & 0x55555555);
  x = (x & 0x33333333) + ((x >> 2) & 0x33333333);
  x = (x + (x >> 4)) & 0x0f0f0f0f;
  x = x + (x >> 8);
  x = x + (x >> 16);
  return x & 0x3f;
}

//产生从lowbit 到 highbit 全为1，其他位为0的数
int bitMask(int highbit, int lowbit) {
  int high = ~((~0) << highbit) << 1;
  int low = ((~0) << lowbit);
  return high & low;
}

//当x+y 会产生溢出时返回1，否则返回 0
int addOK(int x, int y) {
  int sum = x + y;
  int x_neg = x >> 31;
  int y_neg = y >> 31;
  int sum_neg = sum >> 31;
  return !((x_neg ^ y_neg) & (x_neg ^ sum_neg));
}

//将x的第n个字节与第m个字节交换，返回交换后的结果
int byteSwap(int x, int n, int m) {
  n = n << 3;
  m = m << 3;
  int byte_n = (x >> n) & 0xFF;
  int byte_m = (x >> m) & 0xFF;
  int byte_mask = ((0xFF << n) | (0xFF << m));
  return (x & ~byte_mask) | ((byte_n << m) | (byte_m << n));
}

int main()
{
    cout << bitCount(0x7) << endl;
    return 0;
}