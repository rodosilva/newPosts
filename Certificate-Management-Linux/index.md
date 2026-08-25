+++
date = '2026-03-27T21:35:32-05:00'
title = 'Manejo de Certificados en Linux'
+++

## Ubicación de los certificados
Suelen ubicarse en:
```bash
ls -la /etc/ssl/
```

## Datos Prácticos
- **PKCS#1** y **PKCS#8** son formatos de las llaves privadas. Siendo la primera más antigua. Se suele reconocer por `-----BEGIN RSA PRIVATE KEY-----` mientras que la segunda se presenta como `-----BEGIN PRIVATE KEY-----`
- **openssl x509** maneja certificados mientras que **openssl rsa** maneja llaves

## Comandos más Comunes:
Entre los comandos más comunes están:

- La lectura en texto plano del certificado:
```bash
openssl x509 -in <domain>.crt -text -noout
```

 - Ver el certificado presentado actualmente. Ya sea dentro del mismo servidor, o de forma remota:
```bash
openssl s_client -connect localhost:443 </dev/null 2>/dev/null | openssl x509 -noout -subject -issuer -dates -serial
```

- Extraer de un `pfx` el `client cert` sin la `key`. Donde `passin` es el `passphrase` que colocamos al momento de descargar nuestro certificado
```bash
openssl pkcs12 -in <domain>.pfx -clcerts -nokeys -out <domain>.nokey.crt -passin pass:xxxxxxxxxxxxxxx
```

- Extraer de un `pfx` el `CA certificate` sin la `key`:
```bash
openssl pkcs12 -in <domain>.pfx -cacerts -nokeys -out <domain>-chain.pem -passin pass:xxxxxxxxxxxxxxx
```

- Combinar dos certificados de texto plano. En este caso el `client cert` y el `CA cert`:
```bash
cat <domain>.nokey.crt <domain>-chain.pem > <domain>.com.crt
```

- Extraer solo la `Key` (le vuelve a colocar el `passphrase`):
```bash
openssl pkcs12 -in <domain>.pfx -nocerts -out <domain>.key -passin pass:xxxxxxxxxxxxxxx -passout pass:xxxxxxxxxxxxxxx
```

- Convertir la `key` en una `Unencrypted Key`:
```bash
openssl rsa -in <domain>.key -out <domain>.decrypted.key -passin pass:xxxxxxxxxxxxxxx
```

- Validar la que la firma del `CA certificate` sea realmente la que está en el `client certificate` y que la `certificate chain` es correcta `cert -> intermediate CA -> root CA`:
```bash
openssl verify -verbose -CAfile <domain>-chain.pem <domain>.nokey.crt
```
Donde `<domain>-chain.pem` es el `CA certificate` y `<domain>.nokey.crt` es el `client certificate`

- Es posible que un certificado esté como bundle. Donde incluye `client cert -> Intermediate CA -> Root CA`. Para ello podemos usar este comando
```bash
openssl storeutl -noout -text -certs <domain>.crt | grep -E "Subject:|Issuer:|Not before|Not After"
```

- Crear certificados `self-signed`

```bash
openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
  -keyout ./nginx/certs/key.pem \
  -out ./nginx/certs/cert.pem \
  -subj "/CN=bw.local"
```

- Crear Certificate Authority y certificados sobre la base del CA

```bash
openssl genrsa -out myhomelab-ca.key 4096

openssl req -x509 -new -nodes \
-key myhomelab-ca.key \
-sha256 -days 3650 \
-out myhomelab-ca.crt \
-subj "/CN=MyHomeLab CA"

openssl genrsa -out cert.key 2048

openssl req -new -key cert.key -out cert.csr \
-subj "/CN=192.168.1.11"

openssl x509 -req -in cert.csr \
-CA myhomelab-ca.crt \
-CAkey myhomelab-ca.key \
-CAcreateserial \
-out cert.pem \
-days 825 \
-sha256 \
-extfile <(printf "subjectAltName=IP:192.168.1.11")
```

De igual forma para que la PC confíe en el certificado hay que:
```bash
sudo cp myhomelab-ca.crt /usr/local/share/ca-certificates/myhomelab-ca.crt
sudo update-ca-certificates
```

Y el `Chrome` hay que agregar el certificado:
[Certificate Manager Chrome](chrome://certificate-manager/)

