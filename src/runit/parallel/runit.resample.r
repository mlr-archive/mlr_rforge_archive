

test.parallel.resample = function() {
  wl = makeLearner("classif.lda", predict.type="prob")
  res = makeResampleInstance(makeResampleDesc("subsample", iters=4), task=binaryclass.task)

  parallel.setup(mode="local")
  p1 = resample(wl, binaryclass.task, res)
  parallel.setup(mode="multicore", level="resample", cpus=2)
  p2 = resample(wl, binaryclass.task, res)
  parallel.setup(mode="snowfall", level="resample", cpus=2)
  p3 = resample(wl, binaryclass.task, res)
  
  checkEquals(p1@df$response, p2@df$response)
  checkEquals(p1@df$response, p3@df$response)
  parallel.setup(mode="local")
}

