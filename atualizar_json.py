import json
import sys

json_path = r"C:\Users\Usuario\Desktop\Catalogo\produtos.json"
backup_path = r"C:\Users\Usuario\Desktop\Catalogo\produtos_BACKUP.json"

codigo = sys.argv[1]
descricao = sys.argv[2]
marca = sys.argv[3]
valor = float(sys.argv[4])
unidades = int(sys.argv[5])
imagem = sys.argv[6]

# Lê independente se o arquivo estiver ANSI
with open(json_path, "r", encoding="latin-1") as f:
    data = json.load(f)

# Backup
with open(backup_path, "w", encoding="latin-1") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

# Verifica se já existe
produto = next((p for p in data if p["Código"] == codigo), None)

if produto:
    # Atualiza
    produto["descricao"] = descricao
    produto["marca"] = marca
    produto["valor"] = valor
    produto["unidades"] = unidades
    produto["imagem"] = imagem
    print("🔄 Produto atualizado.")
else:
    # Adiciona novo produto
    novo = {
        "Código": codigo,
        "descricao": descricao,
        "marca": marca,
        "valor": valor,
        "unidades": unidades,
        "imagem": imagem
    }
    data.append(novo)
    print("🆕 Produto cadastrado.")

# Salva de volta
with open(json_path, "w", encoding="latin-1") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print("✅ Operação concluída.")
