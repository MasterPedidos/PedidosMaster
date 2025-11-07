from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess, urllib.parse

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):

        # ROTA PARA ATUALIZAR JSON
        if self.path.startswith("/update"):
            try:
                q = urllib.parse.parse_qs(self.path.split("?",1)[1])

                codigo = q.get("codigo",[None])[0]
                descricao = q.get("descricao",[None])[0]
                marca = q.get("marca",[None])[0]
                valor = q.get("valor",[None])[0]
                unidades = q.get("unidades",[None])[0]
                imagem = q.get("imagem",[None])[0]

                if codigo and descricao and marca and valor and unidades and imagem:
                    print(f"→ Atualizando JSON: {codigo} | {descricao}")
                    subprocess.run(["python", "atualizar_json.py", codigo, descricao, marca, valor, unidades, imagem])
                    print("✅ Atualizado com sucesso")

            except Exception as e:
                print("❌ Erro:", e)

            self.send_response(200)
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            self.wfile.write(b"OK")
            return

        # ROTA PARA ENVIAR PARA O GITHUB
        if self.path.startswith("/push"):
            print("📤 Enviando para GitHub...")
            try:
                subprocess.run(["git", "add", "produtos.json"])
                subprocess.run(["git", "commit", "-m", "Atualizado via painel"])
                subprocess.run(["git", "push"])
                msg = "✅ Enviado para o GitHub com sucesso!"
                print(msg)
            except Exception as e:
                msg = f"❌ Erro ao enviar: {e}"
                print(msg)

            self.send_response(200)
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            self.wfile.write(msg.encode())
            return


print("🚀 API ativa em http://localhost:8081")
print("Aguardando comandos...")
HTTPServer(("localhost",8081), Handler).serve_forever()
