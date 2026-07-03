# CLAUDE.md — Convenciones del proyecto my-workspace

## Idioma

- Todas las respuestas deben ser en **español**, a menos que se indique explícitamente algo diferente.
- Todos los nombres (variables, funciones, componentes, archivos) deben estar en **inglés**.
- Si un nombre propuesto tiene un typo o no tiene sentido semántico, preguntar al usuario si desea corregirlo y hacer una sugerencia.

---

## Estructura del proyecto

Este es un monorepo Nx. Cada app vive en `apps/<app-name>/src/` con esta organización:

- `routes/` — rutas de TanStack Router.
- `components/` — componentes reutilizables. `components/ui/` para primitivos shadcn/Radix; el resto agrupado por dominio/flujo (ej. `components/form/`, `components/steps/`).
- `types/` — tipos generales (excepto props de componentes), nombrados por dominio (ej. `form.types.ts`). Buscar siempre si ya existe un archivo antes de crear uno nuevo.
- `services/` — llamadas a API, nombradas por dominio (ej. `address-verification.service.ts`).
- `hooks/`, `lib/`, `constants/`, `data/` — según su propósito.
- Todo componente nuevo con lógica propia va en su carpeta con su mismo nombre.

---

## Componentes

### Funciones

- Usar **siempre arrow functions**, tanto en componentes como en helpers, callbacks y handlers. Nunca usar `function` declarations.
- Antes de crear una función genérica o utilitaria (formateo de fechas, strings, números, etc.), buscar primero en `lib/` o archivos `*.utils.ts` si ya existe una equivalente.
- Si una función es demasiado compleja (más de ~20 líneas, múltiples responsabilidades), extraerla a un archivo dedicado (`<Component>.helpers.ts` o `.utils.ts`) en la misma carpeta.

### Orden dentro de un archivo de componente

1. Imports
2. Interface de props (`Props`)
3. `useState`, `useRef`
4. Definición de constantes
5. Definición de funciones
6. Efectos (`useEffect`)
7. JSX (return)

### Props

- Los props de cada componente se tipan con una interfaz llamada `Props`, ubicada al tope del archivo, después de los imports.
- No usar tipos inline como `prop: { foo: string }` — siempre extraer a la interfaz `Props`.

### JSX limpio

- Definir constantes para lógica fuera del JSX.
- Usar early returns para casos específicos del componente.
- Evitar ternarias que superen una línea de código — preferir bloques de casos explícitos.
- Si hay segmentos JSX repetidos, de más de 3 niveles de indentación, más de 20 líneas, o alta complejidad, extraerlos como componente aparte.

### Constantes y datos estáticos

- Los arrays y objetos de datos estáticos se declaran **dentro de la función del componente**, no a nivel de módulo (salvo que se reutilicen entre componentes, en cuyo caso van en `constants/` o `data/`).

### Optional chaining

- Usar `?.` siempre en accesos a propiedades, métodos de arrays y encadenamiento.

---

## Estilos

- Todos los estilos con **Tailwind CSS** — este proyecto no usa SCSS (sigue el patrón shadcn/ui: Tailwind + `cva` para variantes + `cn()` para merge de clases).
- No usar `!important`.
- No dejar comentarios que expliquen propiedades de Tailwind en términos de CSS.

---

## Documentación

- Funciones, componentes y efectos deben tener documentación breve pero clara usando **JSDoc**, escrita en **español**.
- Si se actualiza algo, actualizar también el JSDoc correspondiente, o crearlo si no existe.

---

## Limpieza de código

- Al modificar un archivo, eliminar todos los imports o constantes no utilizados ni exportados.

---

## TypeScript

- **Nunca usar `any`** — siempre tipar correctamente.
- **Evitar `unknown`** siempre que sea posible; preferir los tipos utilitarios `Pick`, `Omit` y `Partial` sobre tipos existentes. Solo usar `unknown` cuando sea estrictamente necesario y acompañarlo de un type guard o aserción justificada.
