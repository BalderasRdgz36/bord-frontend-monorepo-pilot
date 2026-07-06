# Etapa de build: compila la app indicada del monorepo Nx
# Versión alineada con .nvmrc del workspace
FROM node:24-alpine AS builder
WORKDIR /workspace
COPY . .

# Carpeta dentro de apps/ (define dónde queda el dist)
ARG APP_DIR=bord-address-form
# Nombre del proyecto Nx tal como aparece en `nx show projects` (puede llevar scope, ej. @bord/mfe-address-form)
ARG NX_PROJECT=@bord/mfe-address-form

# Variables de entorno de bord-address-form.
# Si agregas una app con sus propias variables, súmalas aquí siguiendo el mismo patrón.
ARG VITE_SUBSCRIPTION
ENV VITE_SUBSCRIPTION=$VITE_SUBSCRIPTION
ARG VITE_ORGANIZATION
ENV VITE_ORGANIZATION=$VITE_ORGANIZATION

RUN npm ci
RUN npx nx build $NX_PROJECT

# Imagen final
FROM nginx:alpine
ARG APP_DIR=bord-address-form
RUN rm -v /usr/share/nginx/html/index.html
COPY --from=builder /workspace/apps/${APP_DIR}/dist/ /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
