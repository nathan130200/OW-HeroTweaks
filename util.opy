#!mainFile "main.opy"

#!define declareForEach(array) array = [0, array.slice(0, len(array))]\
    printLog("size of for-each like array: {}".format(len(array)))

#!define forEachArray(array) while array[0] < len(array[1])

#!define loopBody(array) array[1][array[0]]

#!define loopIndex(array) array[0]

#!define setHeroCaps(entity, value) entity.setAbility1Enabled(value)\
    entity.setAbility2Enabled(value)\
    entity.setUltEnabled(value)\
    entity.setSecondaryFireEnabled(value)