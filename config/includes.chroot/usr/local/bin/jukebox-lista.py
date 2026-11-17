#!/usr/bin/env python3
# Gera biblioteca.js com a lista de musicas e imagens (igual ao atualizar.ps1 do Windows).
import os, sys, json, unicodedata
base, saida = sys.argv[1], sys.argv[2]
ext = {'.mp3','.wav','.ogg','.oga','.m4a','.aac','.flac','.opus','.wma','.mp4','.m4v','.webm','.mkv','.mov','.avi',
       '.mpg','.mpeg','.3gp','.ogv','.wmv','.jpg','.jpeg','.png','.webp','.gif','.bmp'}
lista = []
for raiz, pastas, arquivos in os.walk(base):
    pastas[:] = sorted(p for p in pastas if not p.startswith('.') and p not in ('System Volume Information', '$RECYCLE.BIN'))
    for a in sorted(arquivos):
        if a.startswith('.'): continue
        if os.path.splitext(a)[1].lower() in ext:
            rel = os.path.relpath(os.path.join(raiz, a), base).replace(os.sep, '/')
            lista.append(unicodedata.normalize('NFC', rel))
with open(saida, 'w', encoding='utf-8') as f:
    f.write('window.BIBLIOTECA=' + json.dumps(lista, ensure_ascii=False) + ';')
print(len(lista), 'arquivos encontrados')
