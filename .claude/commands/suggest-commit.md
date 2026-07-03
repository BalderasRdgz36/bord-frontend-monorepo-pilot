Suggest a commit message for the current staged or unstaged changes.

## Steps

1. Run `git diff HEAD` to review all current changes (staged and unstaged).

2. Analyze the changes and suggest a concise commit message following these rules:
   - Use **conventional commits** format: `type: short description`
   - Types: `feat`, `fix`, `refactor`, `style`, `docs`, `chore`, `test`
   - Description in **English**, imperative tense, lowercase, no period at the end
   - Max 72 characters
   - If the changes span multiple concerns, suggest the most representative type

3. Show the suggested message clearly in a code block.

4. Ask the user ONE question:
   - **a) Copiar** — solo muestra el mensaje para que el usuario lo copie
   - **b) Hacer el commit** — ejecuta el commit con ese mensaje

5. If the user chooses **a)**:
   - Display the message again in a code block, ready to copy. Nothing else.

6. If the user chooses **b)**:
   - Stage all relevant files with `git add` (ask if unsure which files to include)
   - Run `git commit -m "<message>"` with the suggested message
   - Confirm the commit was created successfully showing the output
