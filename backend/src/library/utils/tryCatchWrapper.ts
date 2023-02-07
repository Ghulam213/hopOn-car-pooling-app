/*
 * Generic function that accepts any number of parameters.
 */
type GenericFunction = (...args: any[]) => any;

/*
 * Can be used to wrap a function within a function with the
 * same signature.
 *
 * @param F - Function that should be wrapped.
 */
type TryCatchWrapper<F extends GenericFunction> = (
  ...args: Parameters<F>
) => ReturnType<F>;

/*
 * Wraps a function within a try/catch block to catch any
 * unhandled error.
 *
 * @param func - Function that should be wrapped.
 */
export function tryCatchWrapper<F extends GenericFunction>(
  func: F
): TryCatchWrapper<F> {
  return (...args) => {
    try {
      return func(...args);
    } catch (error) {
      throw error;
    }
  };
}