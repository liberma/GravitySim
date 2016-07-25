#include "vec.hpp"

class PointMass
{
public:
    vec position;
    vec velocity;
    vec acceleration;
    double Mass;

public:
    PointMass (vec c = vec(0,0,0), vec v = vec(0,0,0), double m = 1);
};
    
