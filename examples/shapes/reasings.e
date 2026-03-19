-- raylib easings library ported to Euphoria/Phix, see reasings.h for more information
-- ported to Euphoria/Phix 2026 Andreas Wagner

constant PI = 3.14159265358979323846
constant PI2 =2*PI
--EASEDEF float EaseElasticOut(float t, float b, float c, float d) // Ease: Elastic Out
--{
--  if (t == 0.0f) return b;
--  if ((t/=d) == 1.0f) return (b + c);
--
--  float p = d*0.3f;
--  float a = c;
--  float s = p/4.0f;
--
--  return (a*powf(2.0f,-10.0f*t)*sinf((t*d-s)*(2.0f*PI)/p) + c + b);
--}
--
global function EaseElasticOut(atom t,atom b,atom c,atom d)
atom p,a,s
if t=0 then
    return b
end if
t=t/d
if (t=1) then
    return b+c
end if
p=d*0.3
a=c
s=p/4
return (a*power(2,-10*t)*sin((t*d-s)*(2*PI)/p)+c+b)
end function

--// Elastic Easing functions
--EASEDEF float EaseElasticIn(float t, float b, float c, float d) // Ease: Elastic In
--{
--  if (t == 0.0f) return b;
--  if ((t/=d) == 1.0f) return (b + c);
--
--  float p = d*0.3f;
--  float a = c;
--  float s = p/4.0f;
--  float postFix = a*powf(2.0f, 10.0f*(t-=1.0f));
--
--  return (-(postFix*sinf((t*d-s)*(2.0f*PI)/p )) + b);
--}
global function EaseElasticIn(atom t, atom b, atom c,atom d)
atom p,a,s,postFix
if t=0 then
    return b
end if
t=t/d
if (t=1) then
    return b+c
end if
p=d*0.3
a=c
s=p/4
t=t-1
postFix =a*power(2,10*(t))
return -(postFix*sin((t*d-s)*(PI2)/p))+b

end function

--EASEDEF float EaseElasticInOut(float t, float b, float c, float d) // Ease: Elastic In Out
--{
--  if (t == 0.0f) return b;
--  if ((t/=d/2.0f) == 2.0f) return (b + c);
--
--  float p = d*(0.3f*1.5f);
--  float a = c;
--  float s = p/4.0f;
--
--  if (t < 1.0f)
--  {
--      float postFix = a*powf(2.0f, 10.0f*(t-=1.0f));
--      return -0.5f*(postFix*sinf((t*d-s)*(2.0f*PI)/p)) + b;
--  }
--
--  float postFix = a*powf(2.0f, -10.0f*(t-=1.0f));
--
--  return (postFix*sinf((t*d-s)*(2.0f*PI)/p)*0.5f + c + b);
--}
--
global function EaseElasticInOut (atom t,atom b,atom c,atom d)
atom postFix, p, a, s

if t = 0 then return b end if

t = t / (d / 2) 
if t = 2 then return b + c end if

p = d * (0.3 * 1.5)
a = c
s = p / 4

if t < 1 then
    t = t - 1
    postFix = a * power(2, 10 * t)
    return -0.5 * (postFix * sin((t * d - s) * (2 * PI) / p)) + b
end if

t = t - 1

postFix = a * power(2, -10 * t)
return (postFix * sin((t * d - s) * (2 * PI) / p) * 0.5 + c + b)
end function



--EASEDEF float EaseLinearNone(float t, float b, float c, float d) { return (c*t/d + b); }                          // Ease: Linear
--EASEDEF float EaseLinearIn(float t, float b, float c, float d) { return (c*t/d + b); }                                // Ease: Linear In
--EASEDEF float EaseLinearOut(float t, float b, float c, float d) { return (c*t/d + b); }                           // Ease: Linear Out
--EASEDEF float EaseLinearInOut(float t, float b, float c, float d) { return (c*t/d + b); }                         // Ease: Linear In Out

global function EaseLinearNone(atom t,atom b,atom c,atom d)
    return c*t/d+b
end function
global function EaseLinearIn(atom t,atom b,atom c,atom d)
    return c*t/d+b
end function
global function EaseLinearOut(atom t,atom b,atom c,atom d)
    return c*t/d+b
end function
global function EaseLinearInOut(atom t,atom b,atom c,atom d)
    return c*t/d+b
end function
-- Sine Easing functions
--EASEDEF float EaseSineIn(float t, float b, float c, float d) { return (-c*cosf(t/d*(PI/2.0f)) + c + b); }          // Ease: Sine In
--EASEDEF float EaseSineOut(float t, float b, float c, float d) { return (c*sinf(t/d*(PI/2.0f)) + b); }              // Ease: Sine Out
--EASEDEF float EaseSineInOut(float t, float b, float c, float d) { return (-c/2.0f*(cosf(PI*t/d) - 1.0f) + b); }    // Ease: Sine In Out

global function EaseSineIn(atom t,atom b,atom c,atom d)
    return (-c*cos(t/d*(PI/2.0)) + c + b)
end function

global function EaseSineOut(atom t,atom b,atom c,atom d)
    return (c*sin(t/d*(PI/2.0)) + b)
end function

global function EaseSineInOut(atom t,atom b,atom c,atom d)
    return (-c/2.0*(cos(PI*t/d) - 1.0) + b)
end function

--// Circular Easing functions
--EASEDEF float EaseCircIn(float t, float b, float c, float d) { t /= d; return (-c*(sqrtf(1.0f - t*t) - 1.0f) + b); } // Ease: Circular In
--EASEDEF float EaseCircOut(float t, float b, float c, float d) { t = t/d - 1.0f; return (c*sqrtf(1.0f - t*t) + b); }  // Ease: Circular Out
--EASEDEF float EaseCircInOut(float t, float b, float c, float d)                                                    // Ease: Circular In Out
--{
--  if ((t/=d/2.0f) < 1.0f) return (-c/2.0f*(sqrtf(1.0f - t*t) - 1.0f) + b);
--  t -= 2.0f; return (c/2.0f*(sqrtf(1.0f - t*t) + 1.0f) + b);
--}

global function EaseCircIn(atom t,atom b,atom c,atom d)
t = t/d 
    return (-c*(sqrt(1.0 - t*t) - 1.0) + b)
end function

global function EaseCircOut(atom t,atom b,atom c,atom d)
t = t/d - 1.0 
    return (c*sqrt(1.0 - t*t) + b)
end function

global function EaseCircInOut(atom t,atom b,atom c,atom d)
t=t/(d/2.0)
if ((t) < 1.0) 
then
    return (-c/2.0*(sqrt(1.0 - t*t) - 1.0) + b)
end if
t -= 2.0 
    return (c/2.0*(sqrt(1.0 - t*t) + 1.0) + b)
end function

--// Cubic Easing functions
--EASEDEF float EaseCubicIn(float t, float b, float c, float d) { t /= d; return (c*t*t*t + b); }                    // Ease: Cubic In
--EASEDEF float EaseCubicOut(float t, float b, float c, float d) { t = t/d - 1.0f; return (c*(t*t*t + 1.0f) + b); }  // Ease: Cubic Out
--EASEDEF float EaseCubicInOut(float t, float b, float c, float d)                                                   // Ease: Cubic In Out
--{
--  if ((t/=d/2.0f) < 1.0f) return (c/2.0f*t*t*t + b);
--  t -= 2.0f; return (c/2.0f*(t*t*t + 2.0f) + b);
--}

global function EaseCubicIn(atom t,atom b,atom c,atom d)
t = t / d
return (c * t * t * t + b)
end function

global function EaseCubicOut(atom t,atom b,atom c,atom d)
t=t/d-1
    return (c*(t*t*t+1)+b)
end function

global function EaseCubicInOut(atom t,atom b,atom c,atom d)
t=t/(d/2.0)
if ((t) < 1.0) 
then
    return (c/2.0*t*t*t + b)
end if  
t -= 2.0 
return (c/2.0*(t*t*t + 2.0) + b)
end function

--// Quadratic Easing functions
--EASEDEF float EaseQuadIn(float t, float b, float c, float d) { t /= d; return (c*t*t + b); }                       // Ease: Quadratic In
--EASEDEF float EaseQuadOut(float t, float b, float c, float d) { t /= d; return (-c*t*(t - 2.0f) + b); }            // Ease: Quadratic Out
--EASEDEF float EaseQuadInOut(float t, float b, float c, float d)                                                    // Ease: Quadratic In Out
--{
--  if ((t/=d/2) < 1) return (((c/2)*(t*t)) + b);
--  return (-c/2.0f*(((t - 1.0f)*(t - 3.0f)) - 1.0f) + b);
--}
global function EaseQuadIn(atom t,atom b,atom c,atom d)
t=t/d
return (c*t*t + b)
end function

global function EaseQuadOut(atom t,atom b,atom c,atom d)
t=t/d
return (-c*t*(t - 2.0) + b)
end function

global function EaseQuadInOut(atom t,atom b,atom c,atom d)
t=t/(d/2)
if t<1 then
    return (((c/2)*(t*t)) + b)  
end if
    return (-c/2.0*(((t - 1.0)*(t - 3.0)) - 1.0) + b)
end function

--// Exponential Easing functions
--EASEDEF float EaseExpoIn(float t, float b, float c, float d) { return (t == 0.0f) ? b : (c*powf(2.0f, 10.0f*(t/d - 1.0f)) + b); }     // Ease: Exponential In
--EASEDEF float EaseExpoOut(float t, float b, float c, float d) { return (t == d) ? (b + c) : (c*(-powf(2.0f, -10.0f*t/d) + 1.0f) + b); } // Ease: Exponential Out
--EASEDEF float EaseExpoInOut(float t, float b, float c, float d)                                                                       // Ease: Exponential In Out
--{
--  if (t == 0.0f) return b;
--  if (t == d) return (b + c);
--  if ((t/=d/2.0f) < 1.0f) return (c/2.0f*powf(2.0f, 10.0f*(t - 1.0f)) + b);
--
--  return (c/2.0f*(-powf(2.0f, -10.0f*(t - 1.0f)) + 2.0f) + b);
--}

global function EaseExpoIn(atom t,atom b,atom c,atom d)
if t=0 then
    return b
else
    return (c*power(2.0, 10.0*(t/d - 1.0)) + b)
end if
end function

global function EaseExpoOut(atom t,atom b,atom c,atom d)
if t=d then
    return b+c
else
    return (c*(-power(2.0, -10.0*t/d) + 1.0) + b)
end if
end function

global function EaseExpoInOut(atom t,atom b,atom c,atom d)
if t=0 then
    return b
end if
if t=d then
    return b+c
end if
t=t/(d/2)
if t<1 then
    return (c/2.0*power(2.0, 10.0*(t - 1.0)) + b)
end if
    return (c/2.0*(-power(2.0, -10.0*(t - 1.0)) + 2.0) + b)
end function

--// Back Easing functions
--EASEDEF float EaseBackIn(float t, float b, float c, float d) // Ease: Back In
--{
--  float s = 1.70158f;
--  float postFix = t/=d;
--  return (c*(postFix)*t*((s + 1.0f)*t - s) + b);
--}
--
--EASEDEF float EaseBackOut(float t, float b, float c, float d) // Ease: Back Out
--{
--  float s = 1.70158f;
--  t = t/d - 1.0f;
--  return (c*(t*t*((s + 1.0f)*t + s) + 1.0f) + b);
--}
--
--EASEDEF float EaseBackInOut(float t, float b, float c, float d) // Ease: Back In Out
--{
--  float s = 1.70158f;
--  if ((t/=d/2.0f) < 1.0f)
--  {
--      s *= 1.525f;
--      return (c/2.0f*(t*t*((s + 1.0f)*t - s)) + b);
--  }
--
--  float postFix = t-=2.0f;
--  s *= 1.525f;
--  return (c/2.0f*((postFix)*t*((s + 1.0f)*t + s) + 2.0f) + b);
--}
global function EaseBackIn(atom t,atom b,atom c,atom d)
    atom s = 1.70158
    t=t/d
    atom postFix = t
    return (c*(postFix)*t*((s + 1.0)*t - s) + b)
end function

global function EaseBackOut(atom t,atom b,atom c,atom d)
    atom s = 1.70158
    t = t/d - 1.0
    return (c*(t*t*((s + 1.0)*t + s) + 1.0) + b)
end function

global function EaseBackInOut(atom t,atom b,atom c,atom d)  
    atom s = 1.70158
    t=t/(d/2)
    if t<1 then
        s=s*1.525
        return (c/2.0*(t*t*((s + 1.0)*t - s)) + b)
    end if
    atom postFix = t=t-2.0
    s=s*1.525
    return (c/2.0*((postFix)*t*((s + 1.0)*t + s) + 2.0) + b)
end function

--// Bounce Easing functions
--EASEDEF float EaseBounceOut(float t, float b, float c, float d) // Ease: Bounce Out
--{
--  if ((t/=d) < (1.0f/2.75f))
--  {
--      return (c*(7.5625f*t*t) + b);
--  }
--  else if (t < (2.0f/2.75f))
--  {
--      float postFix = t-=(1.5f/2.75f);
--      return (c*(7.5625f*(postFix)*t + 0.75f) + b);
--  }
--  else if (t < (2.5/2.75))
--  {
--      float postFix = t-=(2.25f/2.75f);
--      return (c*(7.5625f*(postFix)*t + 0.9375f) + b);
--  }
--  else
--  {
--      float postFix = t-=(2.625f/2.75f);
--      return (c*(7.5625f*(postFix)*t + 0.984375f) + b);
--  }
--}
--
--EASEDEF float EaseBounceIn(float t, float b, float c, float d) { return (c - EaseBounceOut(d - t, 0.0f, c, d) + b); } // Ease: Bounce In
--EASEDEF float EaseBounceInOut(float t, float b, float c, float d) // Ease: Bounce In Out
--{
--  if (t < d/2.0f) return (EaseBounceIn(t*2.0f, 0.0f, c, d)*0.5f + b);
--  else return (EaseBounceOut(t*2.0f - d, 0.0f, c, d)*0.5f + c*0.5f + b);
--}
global function EaseBounceOut(atom t,atom b,atom c,atom d)
atom postFix=0
t=t/d
if t < (1/2.75) then
    return (c*(7.5625*t*t) + b) 
elsif (t<(2/2.75)) then
    t=t-(1.5/2.75)
    postFix=t
    return (c*(7.5625*(postFix)*t + 0.75) + b)
elsif (t < (2.5/2.75)) then
    t=t-(2.25/2.75)
    postFix = t
    return (c*(7.5625*(postFix)*t + 0.9375) + b)
else
    t=t-(2.625/2.75)
    postFix = t
    return (c*(7.5625*(postFix)*t + 0.984375) + b)
end if  
end function

global function EaseBounceIn(atom t,atom b,atom c,atom d)   
    return (c - EaseBounceOut(d - t, 0.0, c, d) + b)
end function

global function EaseBounceInOut(atom t,atom b,atom c,atom d)

if (t<d/2) then
    return (EaseBounceIn(t*2.0, 0.0, c, d)*0.5 + b)
else
    return (EaseBounceOut(t*2.0 - d, 0.0, c, d)*0.5 + c*0.5 + b)
end if
end function
