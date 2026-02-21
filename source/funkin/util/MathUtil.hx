package funkin.util;

/**
 * Utilities for performing mathematical operations.
 */
@:nullSafety
class MathUtil
{
  /** Euler's constant and the base of the natural logarithm. */
  public static inline final E:Float = 2.71828182845904523536;

  /** The ratio of a circle's circumference to its diameter. */
  public static inline final PI:Float = 3.14159265358979323846;

  /** Tau (2 * PI). Represents a full 360-degree rotation in radians. */
  public static inline final TAU:Float = 6.28318530717958647692;

  /** Half PI (PI / 2). Represents 90 degrees in radians. */
  public static inline final HALF_PI:Float = 1.57079632679489661923;

  /** Quarter PI (PI / 4). Represents 45 degrees in radians. */
  public static inline final QUARTER_PI:Float = 0.78539816339744830962;

  /** Multiplier to convert degrees to radians. */
  public static inline final DEG2RAD:Float = PI / 180.0;

  /** Multiplier to convert radians to degrees. */
  public static inline final RAD2DEG:Float = 180.0 / PI;

  /** The square root of 2. Useful for normalizing diagonal movement. */
  public static inline final SQRT_2:Float = 1.41421356237309504880;

  /** Half of the square root of 2 (or 1 / SQRT_2). */
  public static inline final SQRT_1_2:Float = 0.70710678118654752440;

  /** The Golden Ratio. Great for UI proportions and procedural generation. */
  public static inline final GOLDEN_RATIO:Float = 1.61803398874989484820;

  /** Machine Epsilon. A remarkably small number used for float comparisons. */
  public static inline final EPSILON:Float = 0.0000001;

  /**
   * Safely compares two floats to see if they are practically equal, 
   * bypassing floating-point rounding errors.
   */
  public static inline function approximatelyEqual(a:Float, b:Float, epsilon:Float = EPSILON):Bool
  {
    return Math.abs(a - b) <= epsilon;
  }

  /**
   * Get the logarithm of a value with a given base.
   */
  public static inline function logBase(base:Float, value:Float):Float
  {
    return Math.log(value) / Math.log(base);
  }

  /**
   * Get the base-2 exponent of a value.
   */
  public static inline function exp2(x:Float):Float
  {
    return Math.pow(2, x);
  }

  /**
   * Euclidean division remainder (always positive).
   */
  public static inline function mod(a:Float, b:Float):Float
  {
    b = Math.abs(b);
    return a - b * Math.floor(a / b);
  }

  /**
   * Helper function to get the fractional part of a value.
   */
  public static inline function fract(x:Float):Float
  {
    return x - Math.floor(x);
  }

  /**
   * Wraps a value around a range (like an angle wrapping between 0 and 360).
   */
  public static inline function wrap(value:Float, min:Float, max:Float):Float
  {
    return mod(value - min, max - min) + min;
  }

  /**
   * Checks if an integer is a power of two (useful for texture generation).
   */
  public static inline function isPowerOfTwo(value:Int):Bool
  {
    return value > 0 && (value & (value - 1)) == 0;
  }

  /**
   * Linear interpolation.
   */
  public static inline function lerp(base:Float, target:Float, alpha:Float):Float
  {
    return base + alpha * (target - base);
  }

  /**
   * The inverse of Lerp. Determines where a value lies between two points (returns 0.0 to 1.0).
   */
  public static inline function inverseLerp(base:Float, target:Float, value:Float):Float
  {
    if (base == target) return 0.0;
    return (value - base) / (target - base);
  }

  /**
   * Maps a value from one range to another. 
   */
  public static inline function remap(value:Float, start1:Float, stop1:Float, start2:Float, stop2:Float):Float
  {
    return lerp(start2, stop2, inverseLerp(start1, stop1, value));
  }

  /**
   * GLSL-style SmoothStep. Interpolates smoothly between two edges.
   */
  public static function smoothStep(edge0:Float, edge1:Float, x:Float):Float
  {
    var t:Float = FlxMath.bound((x - edge0) / (edge1 - edge0), 0.0, 1.0);
    return t * t * (3.0 - 2.0 * t);
  }

  public static function smoothLerpDecay(base:Float, target:Float, deltaTime:Float, halfLife:Float):Float
  {
    if (deltaTime == 0) return base;
    if (base == target) return target;
    return lerp(target, base, exp2(-deltaTime / halfLife));
  }

  public static function smoothLerpPrecision(base:Float, target:Float, deltaTime:Float, duration:Float, precision:Float = 1 / 100):Float
  {
    if (deltaTime == 0) return base;
    if (base == target) return target;
    return lerp(target, base, Math.pow(precision, deltaTime / duration));
  }

  public static inline function snap(base:Float, target:Float, threshold:Float):Float
  {
    return Math.abs(base - target) <= threshold ? target : base;
  }

  public static function easeInOutCirc(x:Float):Float
  {
    if (x <= 0.0) return 0.0;
    if (x >= 1.0) return 1.0;
    return (x < 0.5) 
      ? (1 - Math.sqrt(1 - 4 * x * x)) / 2 
      : (Math.sqrt(1 - 4 * (1 - x) * (1 - x)) + 1) / 2;
  }

  public static function easeInOutBack(x:Float, c:Float = 1.70158):Float
  {
    if (x <= 0.0) return 0.0;
    if (x >= 1.0) return 1.0;
    if (x < 0.5) {
      return (2 * x * x * ((c + 1) * 2 * x - c)) / 2;
    } else {
      var invX:Float = 1 - x;
      return (1 - 2 * invX * invX * ((c + 1) * 2 * invX - c)) / 2;
    }
  }

  public static function easeInBack(x:Float, c:Float = 1.70158):Float
  {
    if (x <= 0.0) return 0.0;
    if (x >= 1.0) return 1.0;
    return (1 + c) * x * x * x - c * x * x;
  }

  public static function easeOutBack(x:Float, c:Float = 1.70158):Float
  {
    if (x <= 0.0) return 0.0;
    if (x >= 1.0) return 1.0;
    var invX:Float = x - 1;
    return 1 + (c + 1) * (invX * invX * invX) + c * (invX * invX);
  }

  /**
   * GCD stands for Greatest Common Divisor.
   * Optimized integer algorithm.
   */
  public static function gcd(m:Int, n:Int):Int
  {
    m = m < 0 ? -m : m;
    n = n < 0 ? -n : n;
    
    var temp:Int;
    while (n != 0)
    {
      temp = m % n;
      m = n;
      n = temp;
    }
    return m;
  }

  /**
   * Least Common Multiple (LCM). Pairs with GCD.
   */
  public static inline function lcm(m:Int, n:Int):Int
  {
    if (m == 0 || n == 0) return 0;
    return Std.int(Math.abs(m * n) / gcd(m, n));
  }

  @:deprecated('Use smoothLerpPrecision instead')
  public static inline function coolLerp(base:Float, target:Float, ratio:Float):Float
  {
    return base + cameraLerp(ratio) * (target - base);
  }

  @:deprecated('Use smoothLerpPrecision instead')
  public static inline function cameraLerp(lerp:Float):Float
  {
    return lerp * (FlxG.elapsed / (1 / 60));
  }

  @:deprecated('Use smoothLerpPrecision instead')
  public static function smoothLerp(current:Float, target:Float, elapsed:Float, duration:Float, precision:Float = 1 / 100):Float
  {
    if (current == target) return target;
    var result:Float = lerp(current, target, 1 - Math.pow(precision, elapsed / duration));
    if (Math.abs(result - target) < (precision * target)) result = target;
    return result;
  }
}
