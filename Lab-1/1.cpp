#include <iostream>
#include <cstring>
#include <cstdio>

using namespace std;

const int N = 10;

struct student {
    char    name[8];
    short   age;
    float   score;
    char    remark[200]; //备注信息
};

student old_s[N];
student new_s[N];

int pack_student_bytebybyte(student* s, int sno, char* buf);     //逐字节压缩
int pack_student_whole(student* s, int sno, char* buf);          //压缩函数，用strcpy实现串的写入
int restore_student(char* buf, int len, student* s);             //解压函数
int print_message(char* buf, int len);                           //输出message的前20个字节的内容
//sno是压缩人数，buf为压缩存储区的首地址

int main()
{
    char message[510]; //存放压缩的数据
    int cnt = 0, cntbuf = 0;

    int N1 = 2, N2 = 3;

    //第0个人为自己
    strcpy(old_s[0].name, "Zheng");
    old_s[0].age = 19;
    old_s[0].score = 04; //学号后两位
    strcpy(old_s[0].remark, "Brilliant");

    strcpy(old_s[1].name, "Feynman");
    old_s[1].age = 70;
    old_s[1].score = 100; //学号后两位
    strcpy(old_s[1].remark, "Brilliant");

    strcpy(old_s[2].name, "Newton");
    old_s[2].age = 86;
    old_s[2].score = 100; //学号后两位
    strcpy(old_s[2].remark, "Brilliant");

    strcpy(old_s[3].name, "Landau");
    old_s[3].age = 81;
    old_s[3].score = 100; //学号后两位
    strcpy(old_s[3].remark, "Brilliant");

    strcpy(old_s[4].name, "Dirac");
    old_s[4].age = 79;
    old_s[4].score = 101; //学号后两位
    strcpy(old_s[4].remark, "Brilliant");  

    //输出压缩前的结果
    while (cnt < 5)
    {
        printf("name=%s\n", old_s[cnt].name);
        printf("age=%hd\n", old_s[cnt].age);
        printf("score=%f\n", old_s[cnt].score);
        printf("remark=%s\n", old_s[cnt].remark);
        printf("\n");
        cnt ++ ;
    }

    cntbuf = pack_student_bytebybyte(old_s, N1, message);

    cntbuf += pack_student_whole(old_s + N1, N2, message + cntbuf);

    print_message(message, cntbuf);

    //以16进制输出前20个字节的内容
    for (int i = 0; i < 20; i++) {
        printf("%02X ", (unsigned char)message[i]);
    }
    printf("\n");

    return 0;

}

int  pack_student_bytebybyte(student* s, int sno, char* buf)
{
    int cnts = 0, cntname = 0, cntage = 0, cntscore = 0, cntremark = 0, cntbuf = 0;
    char* p = (char*)s;
    char* p0 = buf;
    while (cnts < sno)
    {
        //读入name数组
        cntname = 0;
        while (cntname < 8)
        {
            if (*p)
            {
                *p0 = *p;
                cntname++;
                cntbuf++;
                p++;
                p0++;
            }
            else
            {
                *p0 = 0;
                cntbuf++;
                p += (8 - cntname);
                p0++;
                break;
            }
        }
        //读入short
        cntage = 0;
        while (cntage < 2)
        {
            *p0 = *p;
            cntage++;
            cntbuf++;
            p++;
            p0++;
        }
        p += 2;
        //读入float
        cntscore = 0;
        while (cntscore < 4)
        {
            *p0 = *p;
            cntscore++;
            cntbuf++;
            p++;
            p0++;
        }
        //读入remark数组
        cntremark = 0;
        while (cntremark < 200)
        {
            if (*p)
            {
                *p0 = *p;
                cntremark++;
                cntbuf++;
                p++;
                p0++;
            }
            else
            {
                *p0 = 0;
                cntbuf++;
                p += (200 - cntremark);
                p0++;
                break;
            }
        }
        cnts++;
    }
    return cntbuf;//返回压缩后的字节数
}

int  pack_student_whole(student* s, int sno, char* buf)
{
    int cnts = 0;
    char* p0 = buf;
    char* p = NULL;
    while (cnts < sno)
    {
        p = s[cnts].name;
        strcpy(p0, p);
        p0 += (strlen(p) + 1);//读入name数组

        p = (char*)&s[cnts].age;
        *((short*)p0) = *((short*)p);
        p0 += 2;//读入age

        p = (char*)&s[cnts].score;
        *((float*)p0) = *((float*)p);
        p0 += 4;//读入score

        p = s[cnts].remark;
        strcpy(p0, p);
        p0 += (strlen(p) + 1);//读入remark数组

        cnts++;
    }
    return p0 - buf;
}

//从buf中读出数据写入student数组s
int restore_student(char* buf, int len, student* s) //len为存放数据的长度
{
    int cnt = 0;
    char* p0 = buf; //遍历message数组

    while (p0 - buf < len) //
    {
        strcpy(s[cnt].name, p0); //读入name
        p0 += (strlen(p0) + 1); //p移动到age处

        s[cnt].age = *((short*) p0);
        p0 += sizeof(short); //p移动到score处

        s[cnt].score = *((float*) p0);
        p0 += sizeof(float); //p移动到remark处

        strcpy(s[cnt].remark, p0);
        p0 += (strlen(p0) + 1); //p移动到下一个学生的name处

        cnt ++ ;
    }

    return cnt; //返回读取数据的学生人数
}

int print_message(char* buf, int len)
{
    int cnt = 0;
    char* p = buf;

    while (p - buf < len)
    {
        printf("%s ", p);
        p += strlen(p) + 1;//p指针移动到age处
        printf("%hd ", *((short*)p));
        p += 2;//p指针移动到score处
        printf("%f ", *((float*)p));
        p += 4;//p指针移动到remark处
        printf("%s\n", p);
        p += strlen(p) + 1;
        cnt ++ ;//增加学生数
    }

    return cnt; //返回读取数据的学生人数
}