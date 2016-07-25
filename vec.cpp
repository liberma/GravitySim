#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "vec.hpp"


vec::vec (double a, double b, double c)
{
        x = a;
        y = b;
        z = c;
}

vec
vec::operator+(const vec& q) 
const
{
        vec C;

        C.x = this->x + q.x;
        C.y = this->y + q.y;
        C.z = this->z + q.z;

        return C;
}

vec
vec::operator-(const vec& q)
const
{
        vec C;

        C.x = this->x - q.x;
        C.y = this->y - q.y;
        C.z = this->z - q.z;

        return C;
}

vec
vec::operator*(double number)
const
{
        vec C;

        C.x = this->x*number;
        C.y = this->y*number;
        C.z = this->z*number;

        return C;
}

double
vec::operator*(const vec& q)
const
{
       return (this->x * q.x + this->y * q.y + this->z * q.z);
}

vec
vec::cross(const vec& p, const vec& q)
{
        vec C;

        C.x = p.y*q.z - p.z*q.y;
        C.y = p.z*q.x - p.x*q.z;
        C.z = p.x*q.y - p.y*q.x;

        return C;
}

vec
vec::operator/(double number)
const
{
    vec C;
    
    C.x = this->x/number;
    C.y = this->y/number;
    C.z = this->z/number;
    
    return C;
}

double
vec::length()
const
{
        return sqrt(this->length2());
}

double
vec::length2()
const
{
       return (*this)*(*this);
}

double& 
vec::operator[](size_t number)
{
        if(number == 0)
                return this->x;
        if(number == 1)
                return this->y;
        if(number == 2)
                return this->z;
        else {   
                printf("Error");
                exit(1);
                return x;   
        }
}

double  
vec::operator[](size_t number)
const
{
        if(number == 0)
                return this->x;
        if(number == 1)
                return this->y;
        if(number == 2)
                return this->z;
        else {   
                printf("Error");
                exit(1);
                return x;   
        }
}

