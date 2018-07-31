import yaml
import os
from string import Template

filePath = os.path.dirname(__file__)
print(filePath)
fileNamePath = os.path.split(os.path.realpath(__file__))[0]
print(fileNamePath)
yamlPath = os.path.join(fileNamePath,'icons.yml')
print(yamlPath);
f = open(yamlPath,'r',encoding='utf-8')
cont = f.read()
x = yaml.load(cont);
solidClasses = []
solidCodes = []
brandsClasses = []
brandsCodes = []
regularClasses = []
regularCodes = []
allClasses = []
for (k,v) in x.items() :
    if 'private' not in v.keys():
        out = []
        for word in k.replace('-',' ').split(' '):
            out.append(word.capitalize())
        iconClass = ''.join(out)
        for key in v['styles']:
            if key == 'solid':
                solidClasses.append("FAS"+iconClass)
                solidCodes.append("\"\\u{"+v['unicode']+"}\"")
            elif key == 'brands':
                brandsClasses.append("FAB"+iconClass)
                brandsCodes.append("\"\\u{"+v['unicode']+"}\"")
            elif key == 'regular':
                regularClasses.append("FAR"+iconClass)
                regularCodes.append("\"\\u{"+v['unicode']+"}\"")      
allclasses = '\", \"'.join(brandsClasses + regularClasses + solidClasses)  
m = dict(FARegularCase=', '.join(regularClasses),
        FABrandsCase=', '.join(brandsClasses),
        FASolidCase=', '.join(solidClasses),
        FABrandsCodes=', '.join(brandsCodes),
        FASolidCodes=', '.join(solidCodes),
        FARegularCodes=', '.join(regularCodes),
        classStrings = allclasses)
template = Template('\
public enum FARegular:Int {\n\
    static var count: Int {\n\
        return FARegularIcons.count\n\
    }\n\
    \n\
    public var text: String? {\n\
        return FARegularIcons[rawValue]\n\
    }\n\
    case $FARegularCase\n\
}\n\
private let FARegularIcons = [$FARegularCodes]\n\
\n\
public enum FASolid:Int {\n\
    static var count: Int {\n\
        return FASolidIcons.count\n\
    }\n\
    \n\
    public var text: String? {\n\
        return FASolidIcons[rawValue]\n\
    }\n\
    case $FASolidCase\n\
}\n\
private let FASolidIcons = [$FASolidCodes]\n\
\n\
public enum FABrands:Int {\n\
    static var count: Int {\n\
        return FABrandsIcons.count\n\
    }\n\
    \n\
    public var text: String? {\n\
        return FABrandsIcons[rawValue]\n\
    }\n\
    case $FABrandsCase\n\
}\n\
private let FABrandsIcons = [$FABrandsCodes]\n\
\n\
let helper = [\"$classStrings\"]\
').substitute(m);



print(template)