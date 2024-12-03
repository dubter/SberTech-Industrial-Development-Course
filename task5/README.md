# URL Shortener
## Описание

Классический сервис для сокращения ссылок, написанный на Golang. 
Использовался Postgres в качестве основной персистентной базы данных и Redis в качестве кэша для уменьшения latency и нагрузки на Postgres.

## Архитектура

![architecture_diagram](./docs/architecture.png)

## API

```
GET http://localhost                       # Отдает домашнюю html страницу
GET http://localhost/favicon.ico           # Отдает иконку для сайта
GET http://localhost/<code>                # Проксирует короткий URL на заданный URL
POST http://localhost/api/urls             # Создаёт короткий URL
```


## Установка и запуск

Назначение: полноценный отказоустойчивый сервис в `k8s` c использованием Service Mesh `istio`. И соотвественно имеется полный мониторинг: метрики в собирает`prometheus`, готовые дашборды в `grafana`, трейсинг в `jaeger`. 

Также доступна удобная фишка `istio` - граф сервисов:

![](./docs/istio.png)

Чтобы установить в `k8s` с полным мониторингом необходимо:

```
# Создание образа App
docker build -t <image-name>:<tag> .              # Билдим образ для App
docker push <image-name>:<tag>                    # Отправляем в Registry
nano deploy/app.yaml                              # Меняем image на <image-name>:<tag>

# Выбор кластера
kubectl config get-contexts                       # Смотрим список кластеров в k8s
kubectl config use-context <context-name>         # Переключаемся на нужный нам кластер
 
# Istio
kubectl apply -f deploy/istio/1-istio-init.yaml   # Заливаем istio CRD
kubectl apply -f deploy/istio/2-istio.yaml        # Заливаем основные istio компоненты
kubectl apply -f deploy/istio/3-addons            # Заливаем дополнительные istio компоненты для мониторинга
kubectl apply -f deploy/istio/4-kiali-secret.yaml # Создаем секрет для kiali
kubectl apply -f deploy/istio/5-label-ns.yaml     # Ставим лейбл для неймспейса default!!!

# Ждём пока установится Istio...
# Отслеживать можно с помощью: kubectl get pods -n istio-system -w

# K8S
kubectl apply -f deploy/postgres.yaml             # Cтавим Postgres
kubectl apply -f deploy/redis.yaml                # Ставим Redis Cluster
kubectl apply -f deploy/app.yaml                  # Ставим Golang приложение с новым образом

# Ждём пока все установится... 
# Отслеживать можно с помощью: kubectl get pods -w

# Применяем миграции к Postgres:
kubectl port-forward svc/postgres-postgresql 5432:5432
psql -h localhost -p 5432 -U postgres postgres
# Вводим пароль, который лежит в секрете deploy/postrges.yaml, закодированный в base64
# И применяем миграции, которые лежат в папке migrations.

=> http://localhost
=> Profit!
```

![](docs/app.png)