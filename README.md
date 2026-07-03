# bord-frontend-monorepo-pilot

Nx monorepo for Bord's frontend applications and microfrontends (React + Vite).

<a alt="Nx logo" href="https://nx.dev" target="_blank" rel="noreferrer"><img src="https://raw.githubusercontent.com/nrwl/nx/master/images/nx-logo.png" width="45"></a>

[Aprende más sobre esta configuración de workspace](https://nx.dev/getting-started/tutorials/react-monorepo-tutorial?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects) o corre `npx nx graph` para explorar visualmente lo que se generó.

## Requisitos

Este repo fija su versión de Node en `.nvmrc`. Antes de correr cualquier comando, asegúrate de estar en la versión correcta:

```sh
nvm use
```

Usar una versión de Node distinta (por ejemplo, un daemon viejo corriendo con otra versión) es una causa común de que Nx falle al procesar el project graph.

## Proyectos

| App                      | Puerto dev | Puerto preview |
| ------------------------ | ---------- | -------------- |
| `my-app-nx`              | 4200       | 4300           |
| `my-second-app`          | 4201       | 4301           |
| `@bord/mfe-address-form` | 4202       | 4302           |

## Correr tareas

Para levantar el servidor de desarrollo de una app:

```sh
npx nx dev my-app-nx
```

Para levantar todas las apps a la vez:

```sh
npx nx run-many --target=dev --all
```

Para generar un build de producción:

```sh
npx nx build my-app-nx
```

Para ver todos los targets disponibles de un proyecto:

```sh
npx nx show project my-app-nx
```

Estos targets están [inferidos automáticamente](https://nx.dev/concepts/inferred-tasks?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects) o definidos en los archivos `project.json` o `package.json`.

[Más sobre correr tareas en la documentación »](https://nx.dev/features/run-tasks?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

## Agregar nuevos proyectos

Aunque podrías agregar proyectos al workspace manualmente, te conviene usar los [plugins de Nx](https://nx.dev/concepts/nx-plugins?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects) y su función de [generación de código](https://nx.dev/features/generate-code?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects).

Usa el generador del plugin para crear nuevos proyectos.

Para generar una nueva aplicación:

```sh
npx nx g @nx/react:app demo
```

Para generar una nueva librería:

```sh
npx nx g @nx/react:lib mylib
```

Puedes usar `npx nx list` para ver la lista de plugins instalados. Luego, corre `npx nx list <plugin-name>` para conocer las capacidades específicas de un plugin. Alternativamente, [instala Nx Console](https://nx.dev/getting-started/editor-setup?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects) para explorar plugins y generadores desde tu IDE.

[Más sobre los plugins de Nx »](https://nx.dev/concepts/nx-plugins?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects) | [Explorar el registro de plugins »](https://nx.dev/plugin-registry?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

## Convenciones de commits y hooks

Este repo usa [Husky](https://typicode.github.io/husky/) para correr validaciones automáticas en cada commit.

### `pre-commit`

- Formatea los archivos staged con [lint-staged](https://github.com/okonet/lint-staged) + Prettier.
- Corre `lint` y `typecheck` sobre los proyectos afectados con `npx nx affected -t lint,typecheck --uncommitted`.

Si alguna de estas validaciones falla, el commit se cancela hasta corregir los errores.

### `commit-msg`

El mensaje de commit debe seguir el formato de [Conventional Commits](https://www.conventionalcommits.org/):

```
tipo: descripción
```

Tipos permitidos: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

Ejemplo:

```
feat: agregar validación de login
```

## Configurar CI

### Paso 1

Para conectar con Nx Cloud, corre:

```sh
npx nx connect
```

Conectarte a Nx Cloud asegura un pipeline de CI [rápido y escalable](https://nx.dev/ci/intro/why-nx-cloud?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects), con funciones como:

- [Caché remoto](https://nx.dev/ci/features/remote-cache?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [Distribución de tareas entre múltiples máquinas](https://nx.dev/ci/features/distribute-task-execution?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [División automática de tests e2e](https://nx.dev/ci/features/split-e2e-tasks?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [Detección y reintento de tareas inestables](https://nx.dev/ci/features/flaky-tasks?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

### Paso 2

Usa el siguiente comando para configurar un workflow de CI para el workspace:

```sh
npx nx g ci-workflow
```

[Más sobre Nx en CI](https://nx.dev/ci/intro/ci-with-nx#ready-get-started-with-your-provider?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

## Instalar Nx Console

Nx Console es una extensión de editor que mejora tu experiencia de desarrollo. Te permite correr tareas, generar código y mejora el autocompletado de código en tu IDE. Está disponible para VSCode e IntelliJ.

[Instalar Nx Console »](https://nx.dev/getting-started/editor-setup?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

## Enlaces útiles

Aprende más:

- [Más sobre esta configuración de workspace](https://nx.dev/getting-started/tutorials/react-monorepo-tutorial?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [Más sobre Nx en CI](https://nx.dev/ci/intro/ci-with-nx?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [Publicar paquetes con Nx release](https://nx.dev/features/manage-releases?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [¿Qué son los plugins de Nx?](https://nx.dev/concepts/nx-plugins?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

Y únete a la comunidad de Nx:

- [Discord](https://go.nx.dev/community)
- [Síguenos en X](https://twitter.com/nxdevtools) o [LinkedIn](https://www.linkedin.com/company/nrwl)
- [Nuestro canal de Youtube](https://www.youtube.com/@nxdevtools)
- [Nuestro blog](https://nx.dev/blog?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
