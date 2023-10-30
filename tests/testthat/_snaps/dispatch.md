# has nice output

    Code
      s3_dispatch(Sys.Date() + 1)
    Output
      => +.Date
         +.default
       * Ops.Date
         Ops.default
       * + (internal)
    Code
      s3_dispatch(Sys.Date() * 1)
    Output
         *.Date
         *.default
      => Ops.Date
         Ops.default
      -> * (internal)

