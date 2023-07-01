# встановлення базового образу - https://docs.docker.com/engine/reference/builder/#from
# https://medium.com/swlh/alpine-slim-stretch-buster-jessie-bullseye-bookworm-what-are-the-differences-in-docker-62171ed4531d
FROM python:3.10-slim-buster
# додаємо макроінформацію - хто автор і до кого задавать питання
# - https://docs.docker.com/engine/reference/builder/#maintainer-deprecated
LABEL maintainer="Liubov Rubel liuba.rubel@gmail.com"
# за замовчення всі операції виконуються з правами рута.
# наступні шість рядків необхідні для стоврення користувача, який не є рутом
ARG UID=1000
ARG GID=1000
ENV UID=${UID}
ENV GID=${GID}
# тут ми сворюємо користувача з ім'м docker_user, який не є рутом, і його UID за
# замовченням буде 1000 (раніше тут було ARG UID=1000 ENV UID=${UID}), він може бути
# замінений при старті контейнера передачою змінної або в файлі docker-compose.yaml
# або як аргумент команди docker
RUN useradd -m -u $UID docker_user
USER docker_user

WORKDIR /home/docker_user/app

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY . .

CMD ["python3", "-m", "bot.main"]