# SaltJus — controle de processos para advogados (Vercel + Supabase)

App web instalável (PWA), no mesmo modelo do SaltFin, mas totalmente separado: repositório, banco de dados e publicação próprios.

## Estrutura
| Arquivo | Para quê |
|---|---|
| `index.html` | O app inteiro: tela de login, painel, processos, prazos e agenda, clientes, honorários, conta e backup |
| `config.js` | Endereço e chave pública (anon) do Supabase do SaltJus. Essa chave é pública por natureza; a segurança vem das regras do banco |
| `supabase-setup.sql` | Cria a tabela `registros`, as regras de acesso (cada usuário só vê os próprios dados) e a função de excluir conta |
| `vendor/supabase.js` | Biblioteca do Supabase (v2.45.4) |
| `fonts/` | Fontes IBM Plex servidas pelo próprio app |
| `icons/`, `manifest.webmanifest`, `sw.js` | Ícones e arquivos que permitem instalar o app no celular |
| `termos.html`, `privacidade.html`, `legal.css` | Termos de Uso e Política de Privacidade (LGPD) |
| `vercel.json` | Cabeçalhos de segurança, incluindo a política que só permite conexão com o Supabase do SaltJus |

## 1. Banco de dados (Supabase)
O projeto **SaltJus** já foi criado na organização Salt Tech Solution (região São Paulo).
1. No painel do Supabase, abra o projeto SaltJus > SQL Editor > New query.
2. Cole o conteúdo de `supabase-setup.sql` e clique em Run.
3. Em Authentication > URL Configuration, coloque em Site URL o endereço final do app na Vercel e adicione o mesmo endereço em Redirect URLs.
4. (Recomendado) Em Authentication > Providers > Email, defina a senha mínima em 8 caracteres.

## 2. Publicar (Vercel)
1. Envie estes arquivos para o repositório do SaltJus no GitHub (o `index.html` na raiz).
2. Na Vercel: Add New > Project > importe o repositório > Deploy. Não precisa configurar nada; publica como site estático.
3. Volte ao passo 1.3 com o endereço gerado.

## 3. Login com Google (opcional)
O botão já existe. Enquanto o provedor Google não for ativado no Supabase (Authentication > Providers > Google), o app avisa e pede e-mail e senha.

## 4. Como os dados são salvos
Cada cliente, processo, prazo e honorário é uma linha na tabela `registros` (com `tipo` e os dados em `dados`). O app guarda uma cópia no aparelho para abrir rápido e funcionar sem internet; alterações feitas offline sobem sozinhas quando a conexão volta. Ao sair da conta, a cópia local é apagada.

## 5. Ao atualizar o app
Depois de mudar arquivos, aumente a versão em `sw.js` (`jus-v1` → `jus-v2`) para os aparelhos baixarem a versão nova.
