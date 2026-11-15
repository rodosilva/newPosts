+++
date = '2026-10-24T16:28:05-05:00'
title = 'Obsidian: RestAPI And MCP Server'
+++

## Referencias
Esta idea la saqué del video:
- [you need to learn MCP RIGHT NOW!!](https://www.youtube.com/watch?v=GuTcle5edjk)
## Requisitos
Primero necesitamos añadir el `plugin` o extensión a `Obsidian`
- [obsidian-local-rest-api](https://community.obsidian.md/plugins/obsidian-local-rest-api)
- [GitHub](https://github.com/coddingtonbear/obsidian-local-rest-api)

Luego necesitamos instalar `Docker Desktop for Linux`
- [Docker Desktop](https://docs.docker.com/desktop/setup/install/linux/ubuntu/)

Con el `obsidian rest-api`, obtendremos el `Api Key`. Que está en `Configuración -> Local Rest API with MCP`

Y con el `Docker Desktop` obtenemos el `MCP Toolkit`. 

## Ejemplos Simples
### Obsidian API
- Crear un `POST` nuevo:
```bash
curl -k -X POST \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: text/markdown" \
  --data '# Creado desde API!!!' \
  https://127.0.0.1:27124/vault/api.md
```

## Configuración
Desde el `MCP Toolkit` debes configurar
- El `pass`: [GPG-encrypted](https://docs.docker.com/desktop/setup/install/linux/?uuid=54180fdd-aa78-429b-b6a4-42110efdc961#signing-in-with-docker-desktop-for-linux)
	- Con eso podrás darle `Docker Login`
- Crear un perfil
- Añadir un server del `catalog`
	- Aquí es donde se coloca el `Obsidian` `api Key`
- Configurar un cliente 
	- Por ejemplo para `Visual Studio Code`
	```bash
	docker mcp client connect vscode --profile rodo
	```


---

# User guide: Connecting Obsidian to an MCP client through Docker MCP Toolkit

This guide describes the connection path and the setup checkpoints for making an Obsidian vault available to an MCP client through Docker MCP Toolkit. The exact Docker Desktop screens and client configuration can vary by version; keep the API key private and do not copy it into this note.

## Connection overview

The request travels through these components:

```text
MCP client (for example, Copilot in VS Code)
        -> Docker MCP Gateway
        -> Obsidian MCP server / integration
        -> Obsidian Local REST API plugin
        -> Obsidian vault
```

The client asks for a capability, such as listing vault files. The gateway routes the MCP request to an enabled server, and the Obsidian integration uses the Local REST API to access the vault.

## Setup and connection steps

### 1. Enable Obsidian's Local REST API

1. Open the target vault in Obsidian.
2. Install and enable the **Local REST API** community plugin (the existing reference above links to the plugin and its source repository).
3. In the plugin settings, confirm that its local API is running. This setup uses port `27124` and HTTPS; the existing example in this note uses `https://127.0.0.1:27124` from the host.
4. Copy or generate the API key from the plugin settings. Treat it like a password. Do not put the real key in shell history, screenshots, notes, or source control.
5. If the plugin exposes/configures MCP support in its settings, enable the MCP integration as required by the installed version.

### 2. Make the API reachable from Docker

A service address that works on the host as `127.0.0.1` is not automatically reachable from inside a container. Configure the Docker MCP Toolkit/Obsidian integration to use the host-reachable address; in this environment, the connection attempt used `host.docker.internal:27124`.

Confirm that the Obsidian plugin is running and listening on the expected port, and that the host firewall/network policy allows the container to reach it. The exact host alias or networking setting can differ by OS and Docker setup. Do not expose the API port to the public internet.

### 3. Add and configure the Obsidian server in Docker MCP Toolkit

1. In Docker MCP Toolkit, add or enable the Obsidian MCP server/integration.
2. Configure its API base URL to point to the Obsidian API from the gateway/container's point of view, not merely to the host's loopback address. For this setup, the observed endpoint host and port were `host.docker.internal:27124`.
3. Provide the API key through the Toolkit's protected configuration/secret field. Never include the key in this guide.
4. If the plugin uses a self-signed certificate, follow the plugin and Toolkit's TLS configuration guidance. Avoid disabling certificate verification except as a deliberate, local-only diagnostic; do not use that workaround for a public or untrusted connection.
5. Save the configuration and ensure the server is enabled in the gateway.

### 4. Select a Docker MCP Toolkit profile (if used)

A profile is a saved snapshot of enabled MCP servers and their configurations. Create or update a profile after the Obsidian server is configured if you want to preserve that gateway setup. Activate the profile when you want to load its servers into the current gateway. A profile is a configuration convenience; it is not itself an MCP server or client, and it does not replace the API key or network connectivity.

### 5. Connect the MCP client to the gateway

Configure the MCP client to use the Docker MCP Gateway using the connection method supported by that client and Toolkit version. Ensure the gateway is running and that the Obsidian server is among the servers/tools exposed to the client. The client should discover Obsidian tools such as listing files in the vault.

### 6. Verify end-to-end access

Ask the client to list the vault's root files. A successful response proves more than just that the tools are installed: it confirms that a request passed through the client/gateway path and reached the Obsidian vault.

**Verified in this setup:** an earlier listing attempt failed with `connection refused` for `host.docker.internal:27124`; a later call to the Obsidian vault-listing tool succeeded and returned the vault's folders and files. This demonstrates that the Obsidian MCP tools were reachable at the time of the successful test. The exact Toolkit UI actions, profile name, and secret-storage method used during initial provisioning were not recorded here, so check the local Toolkit configuration for those environment-specific details.

## Concepts

- **MCP (Model Context Protocol):** A protocol for an AI application to discover and call tools or access context provided by another process.
- **MCP client:** The AI application that initiates MCP requests and displays or uses the results. In this example, the client is the Copilot environment in which the request is made.
- **MCP server:** A process/integration that offers MCP tools or resources. The Obsidian integration exposes vault operations, such as listing files or reading note content. It translates those MCP calls into requests the Obsidian API can handle.
- **Docker MCP Gateway:** The routing/management layer between MCP clients and configured MCP servers. It can expose enabled servers to clients and manage which tools are available. It is not the vault itself and does not store the notes as its own content store.
- **Docker MCP Toolkit:** The Docker tooling used to configure and manage MCP servers and the gateway. It can make server configuration and profiles available to MCP clients.
- **Profile:** A named snapshot of the gateway's enabled servers and their configurations. Profiles help switch or restore a set of servers; activating one loads that saved configuration into the gateway.
- **Local REST API:** The Obsidian plugin's local HTTP(S) API. It is the interface used by the Obsidian integration to perform vault operations. Its API key authorizes requests; it is separate from MCP client authentication.
- **Tool:** A specific operation exposed by a server, for example listing vault files or retrieving a note. Having a tool listed does not alone prove the API connection works; invoke a harmless read-only tool to test end-to-end access.

## Troubleshooting

- **Connection refused:** The plugin/API may be stopped, the port may be wrong, or the container may be using `127.0.0.1` (which points back to the container). Check the API listener and use a host address reachable from the Docker network.
- **Unauthorized/forbidden response:** Recheck the API key and the Toolkit's secret/configuration field. Do not paste the key into chat or logs.
- **TLS/certificate error:** Check the plugin certificate and the integration's TLS trust settings. Prefer trusting the correct certificate over turning verification off.
- **Tools are missing in the client:** Confirm that the server is enabled in the gateway, the intended profile is active if profiles are used, and the client is connected to that gateway.
- **Listing works but a particular operation fails:** Check the specific tool's permissions, path, and API support separately; successful discovery does not guarantee every operation is authorized.

## References

- [Obsidian Local REST API plugin](https://community.obsidian.md/plugins/obsidian-local-rest-api)
- [Plugin source on GitHub](https://github.com/coddingtonbear/obsidian-local-rest-api)
- [MCP introduction](https://modelcontextprotocol.io/introduction)
- [Docker MCP Toolkit](https://docs.docker.com/ai/mcp-catalog-and-toolkit/)
