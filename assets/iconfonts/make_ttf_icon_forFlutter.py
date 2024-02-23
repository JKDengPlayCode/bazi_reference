import json

with open('iconfont.json','r',encoding='utf-8') as load_f:
    jsondata = json.load(load_f)
    for glyph in jsondata['glyphs']:
        print("static const IconData %s = IconData(%s, fontFamily: 'taijiiconfont');" % (glyph['font_class'],glyph['unicode_decimal']))
