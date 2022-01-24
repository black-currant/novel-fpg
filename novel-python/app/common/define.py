from enum import Enum

class ProductStatus(Enum):
    init = 0x0                 #未上架
    uploading = 0x1            #上架中
    active = 0x2               #已上架
    draft = 0x4                #已下架
    updating = 0x8             #更新中