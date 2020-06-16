FROM archlinux:latest as hugo
RUN pacman -Syy
RUN pacman -S --noconfirm hugo
COPY . /hugo-build
RUN hugo -v --source=/hugo-build --destination=/hugo-build/public

FROM nginx:stable-alpine
RUN mv /usr/share/nginx/html/index.html /usr/share/nginx/html/old-index.html
COPY --from=hugo /hugo-build/public/ /usr/share/nginx/html/
EXPOSE 80
