# Microsoft SQL Server

![CI Testing](https://github.com/linux-system-roles/template/workflows/tox/badge.svg)

This role installs, configures, and starts Microsoft SQL Server.

The role also optimizes the operating system to improve performance and throughput for SQL Server by applying the `mssql` Tuned profile.

The role currently works with SQL Server 2017 and 2019.

## Requirements

* SQL Server requires a machine with at least 2000 megabytes of memory.
* Optional: If you want to input T-SQL statements and stored procedures to SQL Server, you must create a file with the `.sql` extension containing these SQL statements and procedures.

## Role Variables

### `mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula`

Set this variable to `true` to indicate that you accept EULA for installing the `msodbcsql17` package.

The license terms for this product can be downloaded from <https://aka.ms/odbc17eula> and found in `/usr/share/doc/msodbcsql17/LICENSE.txt`.

Default: `false`

Type: `bool`

### `mssql_accept_microsoft_cli_utilities_for_sql_server_eula`

Set this variable to `true` to indicate that you accept EULA for installing the `mssql-tools` package.

The license terms for this product can be downloaded from <http://go.microsoft.com/fwlink/?LinkId=746949> and found in `/usr/share/doc/mssql-tools/LICENSE.txt`.

Default: `false`

Type: `bool`

### `mssql_accept_microsoft_sql_server_standard_eula`

Set this variable to `true` to indicate that you accept EULA for using Microsoft SQL Server.

The license terms for this product can be found in `/usr/share/doc/mssql-server` or downloaded from <https://go.microsoft.com/fwlink/?LinkId=2104078&clcid=0x409>.
The privacy statement can be viewed at <https://go.microsoft.com/fwlink/?LinkId=853010&clcid=0x409>.

Default: `false`

Type: `bool`

### `mssql_version`

The version of the SQL Server to configure.
The role currently supports versions 2017 and 2019.

Default: `2019`

Type: `int`

### `mssql_upgrade`

If you want to upgrade your SQL Server 2017 to 2019, set the `mssql_version` variable to `2019` and this variable to `true`.

Note that the role does not support downgrading SQL Server.

Default: `false`

Type: `bool`

### `mssql_password`

The password for the database sa user.
The password must have a minimum length of 8 characters, include uppercase and lowercase letters, base 10 digits or non-alphanumeric symbols.
Do not use single quotes ('), double quotes ("), and spaces in the password because `sqlcmd` cannot authorize when the password includes those symbols.

This variable is required when you run the role to install SQL Server.

When running this role on a host that has SQL Server installed, the `mssql_password` variable overwrites the existing sa user password to the one that you specified.

Default: `null`

Type: `str`

### `mssql_edition`

The edition of SQL Server to install.

This variable is required when you run the role to install SQL Server.

Use one of the following values:

* `Enterprise`
* `Standard`
* `Web`
* `Developer`
* `Express`
* `Evaluation`
* A product key in the form `#####-#####-#####-#####-#####`, where `#` is a number or a letter.
  For more information, see [Configure SQL Server settings with environment variables on Linux](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-environment-variables?view=sql-server-ver16).

Default: `null`

Type: `str`

### `mssql_tcp_port`

The port that SQL Server listens on.

If you set `mssql_manage_firewall` to `false`, you must open the firewall port defined with the `mssql_tcp_port` variable prior to running this role.

You can change the TCP port by setting this variable to a different port.
If you set `mssql_manage_firewall` to `true` while changing the TCP port, the role closes the previously opened firewall port.

Default: `1433`

Type: `int`

### `mssql_manage_firewall`

Whether to open firewall ports required by this role.

When this variable is set to `true`, the role enables firewall even if it was not enabled.

The role uses the `fedora.linux_system_roles.firewall` role to manage the firewall, hence, only firewall implementations supported by the `fedora.linux_system_roles.firewall` role work.

If you set this variable to `false`, you must open required ports prior to running this role.

Default: `false`

Type: `bool`

### `mssql_ip_address`

The IP address that SQL Server listens on.

If you define this variable, the role configures SQL Server with the defined IP address.

If you do not define this variable when installing SQL Server, the role configures SQL Server to listen on the SQL Server default IP address `0.0.0.0`, that is, to listen on every available network interface.

If you do not define this variable when configuring running SQL Server, the role does not change the IP address setting on SQL Server.

Default: `null`

Type: `str`

### `mssql_input_sql_file`

This variable is deprecated. Use the below variables instead.

### `mssql_pre_input_sql_file` and `mssql_post_input_sql_file`

You can use the role to input a file containing SQL statements or procedures into SQL Server.

* Use `mssql_pre_input_sql_file` to input the SQL file immediately after the role configures SQL Server.
* Use `mssql_post_input_sql_file` to input the SQL file at the end of the role invocation.

With these variables, enter the path to the files containing SQL scripts.

When specifying any of these variables, you must also specify the `mssql_password` variable because authentication is required to input an SQL file to SQL Server.

If you do not pass these variables, the role only configures the SQL Server and does not input any SQL file.

Note that this task is not idempotent, the role always inputs an SQL file if any of these variables is defined.

You can find an example of an SQL file at `tests/sql_script.sql` at the role directory.

You can set these variables to a list of files, or to a string containing single file.
For example:

```yaml
mssql_pre_input_sql_file: script0.sql
mssql_post_input_sql_file:
  - script1.sql
  - script2.sql
```

Default: `null`

Type: `string` or `list`

### `mssql_debug`

Whether or not to print the output of sqlcmd commands.
The role inputs SQL scripts with the sqlcmd command to configure SQL Server for HA or to input users' SQL scripts when you define a [`mssql_pre_input_sql_file`](#mssql_pre_input_sql_file-and-mssql_post_input_sql_file) or [`mssql_post_input_sql_file`](#mssql_pre_input_sql_file-and-mssql_post_input_sql_file) variable.

Default: `false`

Type: `bool`

### `mssql_enable_sql_agent`

Set this variable to `true` or `false` to enable or disable the SQL agent.

Default: `null`

Type: `bool`

### `mssql_install_fts`

Set this variable to `true` or `false` to install or remove the `mssql-server-fts` package that provides full-text search.

Default: `null`

Type: `bool`

### `mssql_install_powershell`

Set this variable to `true` or `false` to install or remove the `powershell` package that provides PowerShell.

Default: `null`

Type: `bool`

### `mssql_enable_ha`

Set this variable to `true` or `false` to install or remove the `mssql-server-ha` package and enable or disable the `hadrenabled` setting.

Default: `null`

Type: `bool`

### `mssql_tune_for_fua_storage`

Set this variable to `true` or `false` to enable or disable settings that improve performance on hosts that support Forced Unit Access (FUA) capability.

Only set this variable to `true` if your hosts are configured for FUA capability.

When set to `true`, the role applies the following settings:

* Set the `traceflag 3979 on` setting to enable trace flag 3979 as a startup parameter
* Set the `control.alternatewritethrough` setting to `0`
* Set the `control.writethrough` setting to `1`

When set to `false`, the role applies the following settings:

* Set the `traceflag 3982 off` parameter to disable trace flag 3979 as a startup parameter
* Set the `control.alternatewritethrough` setting to its default value `0`
* Set the `control.writethrough` setting to its default value `0`

For more details, see SQL Server and Forced Unit Access (FUA) I/O subsystem capability at [Performance best practices and configuration guidelines for SQL Server on Linux](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-performance-best-practices?view=sql-server-ver15).

Default: `null`

Type: `bool`

### `mssql_tls_enable`

Use the variables starting with the `mssql_tls_` prefix to configure SQL Server to encrypt connections using TLS certificates.

You can either use existing TLS certificate and private key files by providing them with [`mssql_tls_cert` and `mssql_tls_private_key`](#mssql_tls_cert-and-mssql_tls_private_key), or use the role to create certificates by providing [`mssql_tls_certificates`](#mssql_tls_certificates).

Set to `true` or `false` to enable or disable TLS encryption.

When set to `true`, the role performs the following tasks:

1. Copies or generates TLS certificate and private key files in `/etc/pki/tls/certs/` and `/etc/pki/tls/private/` directories respectively
2. Configures SQL Server to encrypt connections using TLS certificate and private key

When set to `false`, the role configures SQL Server to not use TLS encryption.
The role does not remove the existing certificate and private key files if this variable is set to `false`.

Default: `null`

Type: `bool`

#### `mssql_tls_certificates`

Use this variable to generate certificate and private key for TLS encryption using the `fedora.linux_system_roles.certificate`.

The value of `mssql_tls_certificates` is set to the variable `certificate_requests`
in the `certificate` role.
For more information, see the `certificate_requests` section in the `certificate` role documentation.

The following example generates a certificate FILENAME.crt in `/etc/pki/tls/certs` and a key FILENAME.key in `/etc/pki/tls/private`.
```yaml
mssql_tls_certificates:
  - name: FILENAME
    dns: *.example.com
    ca: self-sign
```
When you set this variable, you must not set `mssql_tls_cert` and `mssql_tls_private_key` variables.

Default: `[]`

Type: `list of dictionaries`

#### `mssql_tls_cert` and `mssql_tls_private_key`

Paths to the certificate and private key files to copy to SQL Server.

You are responsible for creating and securing TLS certificate and private key files.
It is assumed you have a CA that can issue these files.

When you use these variables, the role copies TLS cert and private key files to SQL Server and configures SQL Server to use these files to encrypt connections.

Default: `null`

Type: `str`

#### `mssql_tls_remote_src`

Only applicable when using [`mssql_tls_cert` and `mssql_tls_private_key`](#mssql_tls_cert-and-mssql_tls_private_key).

Influence whether files provided with `mssql_tls_cert` and `mssql_tls_private_key` need to be transferred or already are present remotely.

If `false`, the role searches for `mssql_tls_cert` and `mssql_tls_private_key` files on the controller node.

If `true`, the role searches for `mssql_tls_cert` and `mssql_tls_private_key` on managed nodes.

Default: `false`

Type: `bool`

#### `mssql_tls_version`

TLS version to use.

Default: `1.2`

Type: `str`

#### `mssql_tls_force`

Set to `true` to replace the existing certificate and private key files on host if they exist at `/etc/pki/tls/certs/` and `/etc/pki/tls/private/` respectively.

Default: `false`

Type: `bool`

### `mssql_rpm_key`

The URL or path to the Microsoft rpm gpg keys.

Default: `https://packages.microsoft.com/keys/microsoft.asc`

Type: `string`

### `mssql_server_repository`

The URL to the Microsoft SQL Server repository.
See `vars/` for default values based on operating system.

Default: `{{ __mssql_server_repository }}`

Type: `string`

### `mssql_client_repository`

The URL to the Microsoft production repository.
See `vars/` for default values based on operating system.

Default: `{{ __mssql_client_repository }}`

Type: `string`

### `mssql_ha_configure`

Use the variables starting with the `mssql_ha_` prefix to configure an SQL Server Always On availability group to provide high availability.

**Prerequisites**

* Ensure that your hosts meet the requirements for high availability configuration, namely DNS resolution configured so that hosts can communicate using short names.
  For more information, see Prerequisites in [Configure SQL Server Always On Availability Group for high availability on Linux](https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-availability-group-configure-ha?view=sql-server-ver15#prerequisites).
* Optional: In SQL Server, create one or more databases to be used for replication.
  Provide databases names to the role with the [`mssql_ha_db_names`](#mssql_ha_db_names) variable.
  You can set the [`mssql_pre_input_sql_file`](#mssql_pre_input_sql_file-and-mssql_post_input_sql_file) variable to pre-create databases.
  For more information, see the description of the [`mssql_ha_db_names`](#mssql_ha_db_names) variable.

  If you do not provide the [`mssql_ha_db_names`](#mssql_ha_db_names) variable, the role creates a cluster without replicating database in it.

Configuring for high availability is not supported on RHEL 7 because the `fedora.linux_system_roles.ha_cluster` role does not support RHEL 7.

Set to `true` to configure for high availability.
Setting to `false` does not remove configuration for high availability.

When set to `true`, the role performs the following tasks:

1. Include the `fedora.linux_system_roles.firewall` role to configure firewall:
     1. Open the firewall port set with the [`mssql_ha_listener_port`](#mssql_ha_listener_port) variable.
     2. Enable the `high-availability` service in firewall.
2. Configure SQL Server for high availability:
     1. Enable AlwaysOn Health events.
     2. Create certificate on the primary replica and distribute to other replicas.
     3. Configure endpoint and availability group.
     4. Configure the user provided with the [`mssql_ha_login`](#mssql_ha_login) variable for
Pacemaker.
3. Optional: Include the `fedora.linux_system_roles.ha_cluster` role to configure Pacemaker.
You must set [`mssql_ha_cluster_run_role`](#mssql_ha_cluster_run_role) to `true` and provide all variables required by the `fedora.linux_system_roles.ha_cluster` role for a proper Pacemaker cluster configuration based on example playbooks in [Setting Up SQL Server and Configuring for High Availability](#Setting_Up_SQL_Server_and_Configuring_for_High_Availability).

Default: `false`

Type: `bool`

#### `mssql_ha_replica_type`

A host variable that specifies the type of the replica to be configured on this host.

See [`Setting Up SQL Server and Configuring for High Availability`](#Setting-Up-SQL-Server-and-Configuring-for-High-Availability) for an example inventory.

The available values are: `primary`, `synchronous`, `asynchronous`, `witness`.

You must set this variable to `primary` for exactly one host.

You can set this variable to `witness` for maximum one host.

Default: no default

Type: `str`

#### `mssql_ha_listener_port`

The TCP port used to replicate data for an Always On availability group.

Note that due to an SQL Server limitation it is not possible to change a listener port number on an existing availability group when the availability group contains a configuration-only replica.
To do that, you must re-create the availability group using the required port number.

If you set `mssql_manage_firewall` to `false`, you must open the firewall port defined with the `mssql_ha_listener_port` variable prior to running this role.

Default: `5022`

Type: `int`

#### `mssql_ha_cert_name`

The name of the certificate used to secure transactions between members of an Always On availability group.

Default: `null`

Type: `str`

#### `mssql_ha_master_key_password`

The password to set for the master key used with the certificate.

Default: `null`

Type: `str`

#### `mssql_ha_private_key_password`

The password to set for the private key used with the certificate.

Default: `null`

Type: `str`

#### `mssql_ha_reset_cert`

Whether to reset certificates used by an Always On availability group or not.

Default: `false`

Type: `bool`

#### `mssql_ha_endpoint_name`

The name of the endpoint to be configured.

Default: `null`

Type: `string`

#### `mssql_ha_ag_name`

The name of the availability group to be configured.

Default: `null`

Type: `string`

#### `mssql_ha_db_names`

This is an optional variable.

You can set this variable to the list of names of one or more existing SQL databases to replicate these database in the cluster.
The role backs up databases provided if no back up newer than 3 hours exists to the `/var/opt/mssql/data/` directory.

If you do not provide this variable when configuring new SQL Server, the role creates a cluster without replicating databases in it.

The role does not remove databases not listed with this variable from existing SQL Server clusters.

You can write a T-SQL script that creates database and feed it into the role with the [`mssql_pre_input_sql_file`](#mssql_pre_input_sql_file-and-mssql_post_input_sql_file) variable.
This way, the role runs your script to create databases after ensuring that SQL Server is running and then replicate these databases for high availability.

For example, you can write a `create_example_db.sql` SQL script that creates a test database and feed it into the SQL Server from the primary replica with `mssql_pre_input_sql_file` prior to running the role.

```yaml
- name: Set facts to create a test DB on primary as a pre task
  set_fact:
    mssql_pre_input_sql_file: create_example_db.sql
  when: mssql_ha_replica_type == 'primary'

- name: Run on all hosts to configure HA cluster
  include_role:
    name: microsoft.sql.server
```

Default: `null`

Type: `string`

#### `mssql_ha_login`

The user created for Pacemaker in SQL Server.
This user is used by the SQL Server Pacemaker resource agent to connect to SQL Server to perform regular database health checks and manage state transitions from replica to primary when needed.

Default: `null`

Type: `string`

#### `mssql_ha_login_password`

The password for the mssql_ha_login user in SQL Server.

Default: `null`

Type: `string`

#### `mssql_ha_cluster_run_role`

Whether to run the `fedora.linux_system_roles.ha_cluster` role from this role.

Note that the `fedora.linux_system_roles.ha_cluster` role has the following limitation:

* This role replaces the configuration of HA Cluster on specified nodes.
  Any settings not specified in the role variables will be lost.
* This role is not idempotent - it always returns changed state.

To work around this limitation, the `microsoft.sql.server` role does not set any variables for the `fedora.linux_system_roles.ha_cluster` role to ensure that any existing Pacemaker configuration is not re-written.

If you want the `microsoft.sql.server` to run the `fedora.linux_system_roles.ha_cluster` role, set `mssql_ha_cluster_run_role: true` and provide variables for the `fedora.linux_system_roles.ha_cluster` role with the `microsoft.sql.server` role invocation based on example playbooks in [Setting Up SQL Server and Configuring for High Availability](#Setting_Up_SQL_Server_and_Configuring_for_High_Availability).

If you do not want the `microsoft.sql.server` to run the `fedora.linux_system_roles.ha_cluster` role and instead want to run the `fedora.linux_system_roles.ha_cluster` role independently of the `microsoft.sql.server` role, set `mssql_ha_cluster_run_role: false`.

Default: `false`

Type: `bool`

#### `mssql_ha_virtual_ip`

The virtual IP address to be configured for the SQL cluster.

The role creates an availability group listener using the following values:

* The port provided with the `mssql_tcp_port` variable,
* The IP address provided with the `mssql_ha_virtual_ip` variable
* The `255.255.255.0` subnet mask

Default: `null`

Type: `string`

## Example Playbooks

This section outlines example playbooks that you can use as a reference.

### Setting up SQL Server

This example shows how to use the role to set up SQL Server with the minimum required variables.

```yaml
- hosts: all
  vars:
    mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula: true
    mssql_accept_microsoft_cli_utilities_for_sql_server_eula: true
    mssql_accept_microsoft_sql_server_standard_eula: true
    mssql_password: "p@55w0rD"
    mssql_edition: Evaluation
  roles:
    - microsoft.sql.server
```

### Setting up SQL Server with Custom Network Parameters

This example shows how to use the role to set up SQL Server, configure it with a custom IP address and TCP port, and open the TCP port in firewall.

```yaml
- hosts: all
  vars:
    mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula: true
    mssql_accept_microsoft_cli_utilities_for_sql_server_eula: true
    mssql_accept_microsoft_sql_server_standard_eula: true
    mssql_password: "p@55w0rD"
    mssql_edition: Evaluation
    mssql_tcp_port: 1433
    mssql_ip_address: 0.0.0.0
    mssql_manage_firewall: true
  roles:
    - microsoft.sql.server
```

### Setting Up SQL Server and Enabling Additional Functionality

This example shows how to use the role to set up SQL Server and enable the following additional functionality:

* Enable the SQL Agent
* Install FTS
* Install PowerShell
* Configure SQL Server for FUA capability
* After SQL Server is set up, input an SQL file to SQL Server

```yaml
- hosts: all
  vars:
    mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula: true
    mssql_accept_microsoft_cli_utilities_for_sql_server_eula: true
    mssql_accept_microsoft_sql_server_standard_eula: true
    mssql_password: "p@55w0rD"
    mssql_edition: Evaluation
    mssql_manage_firewall: true
    mssql_enable_sql_agent: true
    mssql_install_fts: true
    mssql_install_powershell: true
    mssql_tune_for_fua_storage: true
    mssql_pre_input_sql_file: myusers.sql
    mssql_post_input_sql_file: mydatabases.sql
  roles:
    - microsoft.sql.server
```

### Setting Up SQL Server with TLS Encryption

This example shows how to use the role to set up SQL Server and configure it to use TLS encryption.
Certificate files `mycert.pem` and `mykey.key` must exist on the primary node.

```yaml
- hosts: all
  vars:
    mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula: true
    mssql_accept_microsoft_cli_utilities_for_sql_server_eula: true
    mssql_accept_microsoft_sql_server_standard_eula: true
    mssql_password: "p@55w0rD"
    mssql_edition: Evaluation
    mssql_manage_firewall: true
    mssql_tls_enable: true
    mssql_tls_cert: mycert.pem
    mssql_tls_private_key: mykey.key
    mssql_tls_version: 1.2
    mssql_tls_force: false
  roles:
    - microsoft.sql.server
```

This example shows how to use the role to set up SQL Server and configure it with TLS encryption using self-signed certificate and key created by the certificate role.

```yaml
- hosts: all
  vars:
    mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula: true
    mssql_accept_microsoft_cli_utilities_for_sql_server_eula: true
    mssql_accept_microsoft_sql_server_standard_eula: true
    mssql_password: "p@55w0rD"
    mssql_edition: Evaluation
    mssql_manage_firewall: true
    mssql_tls_enable: true
    mssql_tls_certificates:
      - name: cert_name
        dns: *.example.com
        ca: self-sign
  roles:
    - microsoft.sql.server
```


### Setting Up SQL Server and Configuring for High Availability

Examples in this section shows how to use the role to set up SQL Server and configure it for high availability in different environments.

#### Configuring the Ansible Inventory

You must set the `mssql_ha_replica_type` variable for each host that you want to configure.

If you set [`mssql_ha_cluster_run_role`](#mssql_ha_cluster_run_role) to `true`, you can provide variables required by the `fedora.linux_system_roles.ha_cluster` role.
If you do not provide names or addresses, the `fedora.linux_system_roles.ha_cluster` uses play's targets, and the high availability setup requires pacemaker to be configured with short names.
Therefore, if you define hosts in inventory not by short names, or the default hosts' IP address differs from the IP address that pacemaker must use, you must set the corresponding `fedora.linux_system_roles.ha_cluster` role variables.

See the `fedora.linux_system_roles.ha_cluster` role's documentation for more information.

The following example inventory describes different cases:

```yaml
all:
  hosts:
    # host1 is defined by a short name
    # There is no need to specify ha_cluster names explicitly
    host1:
      mssql_ha_replica_type: primary
    # host2 and host3 is defined by FQDN
    # You must define ha_cluster names to be in the short name format
    host2.example.com:
      mssql_ha_replica_type: synchronous
      ha_cluster:
        node_name: host2
        pcs_address: host2
    host3.example.com:
      mssql_ha_replica_type: asynchronous
      ha_cluster:
        node_name: host3
        pcs_address: host3
    # host4 is defined by an ip address
    # You must define ha_cluster names to be in the short name format
    # In the case where the default host's IP address differs from the IP
    # address that Pacemaker must use to set up cluster, you must define
    # ha_cluster corosync_addresses
    192.XXX.XXX.333:
      mssql_ha_replica_type: witness
      ha_cluster:
        node_name: host4
        pcs_address: host4
        corosync_addresses:
          - 10.XXX.XXX.333
```

#### Configuring SQL Server HA without Pacemaker

If you want to configure Pacemaker independently, you can set [`mssql_ha_cluster_run_role`](#mssql_ha_cluster_run_role) to `false` to not include the `fedora.linux_system_roles.ha_cluster` role.

Note that production environments require Pacemaker configured with fencing agents.

```yaml
- hosts: all
  vars:
    mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula: true
    mssql_accept_microsoft_cli_utilities_for_sql_server_eula: true
    mssql_accept_microsoft_sql_server_standard_eula: true
    mssql_password: "p@55w0rD"
    mssql_edition: Evaluation
    mssql_manage_firewall: true
    mssql_ha_configure: true
    mssql_ha_listener_port: 5022
    mssql_ha_cert_name: ExampleCert
    mssql_ha_master_key_password: "p@55w0rD1"
    mssql_ha_private_key_password: "p@55w0rD2"
    mssql_ha_reset_cert: false
    mssql_ha_endpoint_name: Example_Endpoint
    mssql_ha_ag_name: ExampleAG
    mssql_ha_db_names:
      - ExampleDB1
      - ExampleDB2
    mssql_ha_login: ExamleLogin
    mssql_ha_login_password: "p@55w0rD3"
    mssql_ha_virtual_ip: 192.XXX.XXX.XXX
    mssql_ha_cluster_run_role: false
  roles:
    - microsoft.sql.server
```

#### Configuring SQL Server with HA and Pacemaker on Bare Metal

If you want to configure Pacemaker from this role, you can set [`mssql_ha_cluster_run_role`](#mssql_ha_cluster_run_role) to `true` and provide variables required by the `fedora.linux_system_roles.ha_cluster` role to configure Pacemaker for your environment properly.

This example configures required Pacemaker properties and resources and enables SBD watchdog.

The `fedora.linux_system_roles.ha_cluster` role expects watchdog devices to be configured on `/dev/watchdog` by default, you can set a different device per host in inventory.
For more information, see the `fedora.linux_system_roles.ha_cluster` role documentation.

```yaml
- hosts: all
  vars:
    mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula: true
    mssql_accept_microsoft_cli_utilities_for_sql_server_eula: true
    mssql_accept_microsoft_sql_server_standard_eula: true
    mssql_password: "p@55w0rD"
    mssql_edition: Evaluation
    mssql_manage_firewall: true
    mssql_ha_configure: true
    mssql_ha_listener_port: 5022
    mssql_ha_cert_name: ExampleCert
    mssql_ha_master_key_password: "p@55w0rD1"
    mssql_ha_private_key_password: "p@55w0rD2"
    mssql_ha_reset_cert: false
    mssql_ha_endpoint_name: Example_Endpoint
    mssql_ha_ag_name: ExampleAG
    mssql_ha_db_names:
      - ExampleDB1
      - ExampleDB2
    mssql_ha_login: ExampleLogin
    mssql_ha_login_password: "p@55w0rD3"
    mssql_ha_virtual_ip: 192.XXX.XXX.XXX
    mssql_ha_cluster_run_role: true
    ha_cluster_cluster_name: "{{ mssql_ha_ag_name }}"
    ha_cluster_hacluster_password: "p@55w0rD4"
    ha_cluster_sbd_enabled: true
    ha_cluster_cluster_properties:
      - attrs:
          - name: cluster-recheck-interval
            value: 2min
          - name: start-failure-is-fatal
            value: true
          - name: stonith-enabled
            value: true
          - name: stonith-watchdog-timeout
            value: 10
    ha_cluster_resource_primitives:
      - id: ag_cluster
        agent: ocf:mssql:ag
        instance_attrs:
          - attrs:
              - name: ag_name
                value: "{{ mssql_ha_ag_name }}"
        meta_attrs:
          - attrs:
              - name: failure-timeout
                value: 60s
      - id: virtualip
        agent: ocf:heartbeat:IPaddr2
        instance_attrs:
          - attrs:
              - name: ip
                value: "{{ mssql_ha_virtual_ip }}"
        operations:
          - action: monitor
            attrs:
              - name: interval
                value: 30s
    ha_cluster_resource_clones:
      - resource_id: ag_cluster
        promotable: yes
        meta_attrs:
          - attrs:
              - name: notify
                value: true
    ha_cluster_constraints_colocation:
      - resource_leader:
          id: ag_cluster-clone
          role: Promoted
        resource_follower:
          id: virtualip
        options:
          - name: score
            value: INFINITY
    ha_cluster_constraints_order:
      - resource_first:
          id: ag_cluster-clone
          action: promote
        resource_then:
          id: virtualip
          action: start
  roles:
    - microsoft.sql.server
```

#### Configuring SQL Server with HA and Pacemaker on VMWare

If you want to configure Pacemaker from this role, you can set [`mssql_ha_cluster_run_role`](#mssql_ha_cluster_run_role) to `true` and provide variables required by the `fedora.linux_system_roles.ha_cluster` role to configure Pacemaker for your environment properly.
See the `fedora.linux_system_roles.ha_cluster` role documentation for more information.

Note that production environments require Pacemaker configured with fencing agents, this example playbook configures the `stonith:fence_vmware_soap` agent.

```yaml
- hosts: all
  vars:
    mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula: true
    mssql_accept_microsoft_cli_utilities_for_sql_server_eula: true
    mssql_accept_microsoft_sql_server_standard_eula: true
    mssql_password: "p@55w0rD"
    mssql_edition: Evaluation
    mssql_manage_firewall: true
    mssql_ha_configure: true
    mssql_ha_listener_port: 5022
    mssql_ha_cert_name: ExampleCert
    mssql_ha_master_key_password: "p@55w0rD1"
    mssql_ha_private_key_password: "p@55w0rD2"
    mssql_ha_reset_cert: false
    mssql_ha_endpoint_name: Example_Endpoint
    mssql_ha_ag_name: ExampleAG
    mssql_ha_db_names:
      - ExampleDB1
      - ExampleDB2
    mssql_ha_login: ExampleLogin
    mssql_ha_login_password: "p@55w0rD3"
    mssql_ha_virtual_ip: 192.XXX.XXX.XXX
    mssql_ha_cluster_run_role: true
    ha_cluster_cluster_name: "{{ mssql_ha_ag_name }}"
    ha_cluster_hacluster_password: "p@55w0rD4"
    ha_cluster_cluster_properties:
      - attrs:
          - name: cluster-recheck-interval
            value: 2min
          - name: start-failure-is-fatal
            value: true
          - name: stonith-enabled
            value: true
    ha_cluster_resource_primitives:
      - id: vmfence
        agent: stonith:fence_vmware_soap
        instance_attrs:
          - attrs:
              - name: username
                value: vmware_Login
              - name: passwd
                value: vmware_password
              - name: ip
                value: vmware_ip
              - name: ssl_insecure
                value: 1
      - id: ag_cluster
        agent: ocf:mssql:ag
        instance_attrs:
          - attrs:
              - name: ag_name
                value: "{{ mssql_ha_ag_name }}"
        meta_attrs:
          - attrs:
              - name: failure-timeout
                value: 60s
      - id: virtualip
        agent: ocf:heartbeat:IPaddr2
        instance_attrs:
          - attrs:
              - name: ip
                value: "{{ mssql_ha_virtual_ip }}"
        operations:
          - action: monitor
            attrs:
              - name: interval
                value: 30s
    ha_cluster_resource_clones:
      - resource_id: ag_cluster
        promotable: yes
        meta_attrs:
          - attrs:
              - name: notify
                value: true
    ha_cluster_constraints_colocation:
      - resource_leader:
          id: ag_cluster-clone
          role: Promoted
        resource_follower:
          id: virtualip
        options:
          - name: score
            value: INFINITY
    ha_cluster_constraints_order:
      - resource_first:
          id: ag_cluster-clone
          action: promote
        resource_then:
          id: virtualip
          action: start
  roles:
    - microsoft.sql.server
```

#### Configuring SQL Server with HA and Pacemaker on Azure

If you want to configure Pacemaker from this role, you can set [`mssql_ha_cluster_run_role`](#mssql_ha_cluster_run_role) to `true` and provide variables required by the `fedora.linux_system_roles.ha_cluster` role to configure Pacemaker for your environment properly.
See the `fedora.linux_system_roles.ha_cluster` role documentation for more information.

**Prerequisites**
You must configure all required resources in Azure.
For more information, see the following articles in Microsoft documentation:

* [Setting up Pacemaker on Red Hat Enterprise Linux in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/workloads/sap/high-availability-guide-rhel-pacemaker#1-create-the-stonith-devices)
* [Tutorial: Configure availability groups for SQL Server on RHEL virtual machines in Azure](https://docs.microsoft.com/en-us/azure/azure-sql/virtual-machines/linux/rhel-high-availability-stonith-tutorial?view=azuresql)

Note that production environments require Pacemaker configured with fencing agents, this example playbook configures the `stonith:fence_azure_arm` agent.

This example playbooks sets the `firewall` variables for the `fedora.linux_system_roles.firewall` role and then runs this role to open the probe port configured in Azure.

```yaml
- hosts: all
  vars:
    mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula: true
    mssql_accept_microsoft_cli_utilities_for_sql_server_eula: true
    mssql_accept_microsoft_sql_server_standard_eula: true
    mssql_manage_firewall: true
    mssql_password: "p@55w0rD"
    mssql_edition: Evaluation
    mssql_ha_configure: true
    mssql_ha_listener_port: 5022
    mssql_ha_cert_name: ExampleCert
    mssql_ha_master_key_password: "p@55w0rD1"
    mssql_ha_private_key_password: "p@55w0rD2"
    mssql_ha_reset_cert: false
    mssql_ha_endpoint_name: Example_Endpoint
    mssql_ha_ag_name: ExampleAG
    mssql_ha_db_names:
      - ExampleDB1
      - ExampleDB2
    mssql_ha_login: ExampleLogin
    mssql_ha_login_password: "p@55w0rD3"
    # Set mssql_ha_virtual_ip to the frontend IP address configured in the Azure
    # load balancer
    mssql_ha_virtual_ip: 192.XXX.XXX.XXX
    mssql_ha_cluster_run_role: true
    ha_cluster_cluster_name: "{{ mssql_ha_ag_name }}"
    ha_cluster_hacluster_password: "p@55w0rD4"
    ha_cluster_extra_packages:
      - fence-agents-azure-arm
    ha_cluster_cluster_properties:
      - attrs:
          - name: cluster-recheck-interval
            value: 2min
          - name: start-failure-is-fatal
            value: true
          - name: stonith-enabled
            value: true
          - name: stonith-timeout
            value: 900
    ha_cluster_resource_primitives:
      - id: rsc_st_azure
        agent: stonith:fence_azure_arm
        instance_attrs:
          - attrs:
              - name: login
                value: ApplicationID
              - name: passwd
                value: servicePrincipalPassword
              - name: resourceGroup
                value: resourceGroupName
              - name: tenantId
                value: tenantID
              - name: subscriptionId
                value: subscriptionID
              - name: power_timeout
                value: 240
              - name: pcmk_reboot_timeout
                value: 900
      - id: azure_load_balancer
        agent: azure-lb
        instance_attrs:
          - attrs:
            # probe port configured in Azure
            - name: port
              value: 59999
      - id: ag_cluster
        agent: ocf:mssql:ag
        instance_attrs:
          - attrs:
            - name: ag_name
              value: "{{ mssql_ha_ag_name }}"
        meta_attrs:
          - attrs:
            - name: failure-timeout
              value: 60s
      - id: virtualip
        agent: ocf:heartbeat:IPaddr2
        instance_attrs:
          - attrs:
            - name: ip
              value: "{{ mssql_ha_virtual_ip }}"
        operations:
          - action: monitor
            attrs:
              - name: interval
                value: 30s
    ha_cluster_resource_groups:
      - id: virtualip_group
        resource_ids:
          - azure_load_balancer
          - virtualip
    ha_cluster_resource_clones:
      - resource_id: ag_cluster
        promotable: yes
        meta_attrs:
          - attrs:
            - name: notify
              value: true
    ha_cluster_constraints_colocation:
      - resource_leader:
          id: ag_cluster-clone
          role: Promoted
        resource_follower:
          id: azure_load_balancer
        options:
          - name: score
            value: INFINITY
    ha_cluster_constraints_order:
      - resource_first:
          id: ag_cluster-clone
          action: promote
        resource_then:
          id: azure_load_balancer
          action: start
    # Variables to open the probe port configured in Azure in firewall
    firewall:
      - port: 59999/tcp
        state: enabled
        permanent: true
        runtime: true
  roles:
    - fedora.linux_system_roles.firewall
    - microsoft.sql.server
```

## License

MIT
