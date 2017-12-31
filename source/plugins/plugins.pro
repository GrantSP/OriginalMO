TEMPLATE = subdirs

SUBDIRS += \
    iniEditor \
    NMMImport \
    installerManual \
    installerNCC \
    installerBAIN \
    installerFomod \
    installerQuick \
    installerBundle \
    proxyPython \
    diagnoseBasic \
    pyniEdit \
    checkFNIS \
    previewBase \
    bsaExtractor \
    gamefeatures \
    gameGamebryo \
    gameOblivion \
    gameSkyrim \
    gameFallout3 \
    gameFalloutNV

plugins.depends = gameSkyrim gameOblivion gameFallout3 gameFalloutNV
gameSkyrim.depends = gameGamebryo
gameOblivion.depends = gameGamebryo
gameFallout3.depends = gameGamebryo
gameFalloutNV.depends = gameGamebryo

OTHER_FILES +=\
    SConscript
