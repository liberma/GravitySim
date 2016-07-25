#ifndef VEC_HPP
# define VEC_HPP
#include <stdlib.h>

class vec
{
public:
        double x;
        double y;
        double z;

public:
        vec(double a = 0, double b = 0, double c = 0);

        vec operator+(const vec& q) const;
        vec operator-(const vec& q) const;
        vec operator*(double number) const;
        vec operator/(double number) const;
        double operator*(const vec& q) const;
        double& operator[](size_t number);
        double operator[](size_t number) const;
        static vec cross(const vec& p, const vec& q);
        double length() const;
        double length2() const;
};

        //vec operator*(double number, vec v)
#endif
