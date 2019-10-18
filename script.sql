create database SimWorld collate SQL_Latin1_General_CP1_CI_AS
go

create table Account
(
    username  varchar(30)     not null
        primary key,
    password  varchar(30)     not null,
    fullName  nvarchar(30),
    isRemoved bit default '0' not null
)
go

create table NetworkOperator
(
    id   int identity
        constraint NetworkOperator_pk
            primary key nonclustered,
    name varchar(30) not null
)
go

create unique index NetworkOperator_name_uindex
    on NetworkOperator (name)
go

create table [Order]
(
    id        int identity
        constraint Order_pk
            primary key nonclustered,
    name      nvarchar(30) not null,
    phoneMask varchar(11),
    timestamp nvarchar(30)
)
go

create unique index Order_id_uindex
    on [Order] (id)
go

create unique index Order_phoneMask_name_timestamp_uindex
    on [Order] (phoneMask, name, timestamp)
go

create table PhongThuy
(
    number int            not null
        constraint PhongThuy_pk
            primary key nonclustered,
    mean   nvarchar(1000) not null,
    brief  nvarchar(50)   not null
)
go

create unique index PhongThuy_number_uindex
    on PhongThuy (number)
go

create table Supplier
(
    id      int identity
        constraint Supplier_pk
            primary key nonclustered,
    name    nvarchar(30)  not null,
    website varchar(2048) not null
)
go

create unique index Supplier_id_uindex
    on Supplier (id)
go

create unique index Supplier_name_uindex
    on Supplier (name)
go

create unique index Supplier_website_uindex
    on Supplier (website)
go

create table Tag
(
    id      int identity
        constraint Tag_pk
            primary key nonclustered,
    tagName nvarchar(30) not null
)
go

create table Sim
(
    phone             varchar(10) not null
        constraint Sim_pk
            primary key nonclustered,
    price             bigint      not null,
    networkOperatorId int         not null
        constraint Sim_NetworkOperator_id_fk
            references NetworkOperator
            on delete cascade,
    tagId             int
        constraint Sim_Tag_id_fk
            references Tag
            on delete cascade,
    supplierId        int         not null
        constraint Sim_Supplier_id_fk
            references Supplier,
    phongThuyNumber   int
)
go

create unique index Sim_phone_uindex
    on Sim (phone)
go

create unique index Tag_tagName_uindex
    on Tag (tagName)
go

create table sys.filestream_tombstone_2073058421
(
    column_guid              uniqueidentifier,
    file_id                  int              not null,
    filestream_value_name    nvarchar(260),
    oplsn_bOffset            int              not null,
    oplsn_fseqno             int              not null,
    oplsn_slotid             int              not null,
    rowset_guid              uniqueidentifier not null,
    size                     bigint,
    status                   bigint           not null,
    transaction_sequence_num bigint           not null
)
go

create unique clustered index FSTSClusIdx
    on sys.filestream_tombstone_2073058421 (oplsn_fseqno, oplsn_bOffset, oplsn_slotid)
go

create index FSTSNCIdx
    on sys.filestream_tombstone_2073058421 (file_id, rowset_guid, column_guid, oplsn_fseqno, oplsn_bOffset,
                                            oplsn_slotid)
go

create table sys.filetable_updates_2105058535
(
    item_guid     uniqueidentifier not null,
    oplsn_bOffset int              not null,
    oplsn_fseqno  int              not null,
    oplsn_slotid  int              not null,
    table_id      bigint           not null
)
go

create unique clustered index FFtUpdateIdx
    on sys.filetable_updates_2105058535 (table_id, oplsn_fseqno, oplsn_bOffset, oplsn_slotid, item_guid)
go

create table sys.persistent_version_store
(
    min_len           smallint,
    prev_row_in_chain binary(8)       not null,
    row_version       varbinary(8000) not null,
    rowset_id         bigint          not null,
    sec_version_rid   binary(8)       not null,
    seq_num           bigint,
    subid_push        int,
    subid_tran        int,
    xdes_ts_push      bigint          not null,
    xdes_ts_tran      bigint          not null
)
go

create table sys.persistent_version_store_long_term
(
    min_len           smallint,
    prev_row_in_chain binary(8)       not null,
    row_version       varbinary(8000) not null,
    rowset_id         bigint          not null,
    sec_version_rid   binary(8)       not null,
    seq_num           bigint,
    subid_push        int,
    subid_tran        int,
    xdes_ts_push      bigint          not null,
    xdes_ts_tran      bigint          not null
)
go

create table sys.plan_persist_context_settings
(
    acceptable_cursor_options int      not null,
    compatibility_level       smallint not null,
    context_settings_id       bigint   not null,
    date_first                tinyint  not null,
    date_format               smallint not null,
    default_schema_id         int      not null,
    is_replication_specific   bit      not null,
    language_id               smallint not null,
    merge_action_type         smallint not null,
    required_cursor_options   int      not null,
    set_options               int      not null,
    status                    smallint not null,
    status2                   tinyint  not null
)
go

create unique clustered index plan_persist_context_settings_cidx
    on sys.plan_persist_context_settings (context_settings_id desc)
go

create table sys.plan_persist_plan
(
    compatibility_level        smallint       not null,
    count_compiles             bigint         not null,
    engine_version             bigint         not null,
    force_failure_count        bigint         not null,
    initial_compile_start_time datetimeoffset not null,
    is_forced_plan             bit            not null,
    is_online_index_plan       bit            not null,
    is_parallel_plan           bit            not null,
    is_trivial_plan            bit            not null,
    last_compile_duration      bigint         not null,
    last_compile_start_time    datetimeoffset not null,
    last_execution_time        datetimeoffset,
    last_force_failure_reason  int            not null,
    plan_flags                 int,
    plan_group_id              bigint,
    plan_id                    bigint         not null,
    query_id                   bigint         not null,
    query_plan                 varbinary(max),
    query_plan_hash            binary(8)      not null,
    total_compile_duration     bigint         not null
)
go

create unique clustered index plan_persist_plan_cidx
    on sys.plan_persist_plan (plan_id)
go

create index plan_persist_plan_idx1
    on sys.plan_persist_plan (query_id desc)
go

create table sys.plan_persist_query
(
    batch_sql_handle                varbinary(64),
    compile_count                   bigint         not null,
    context_settings_id             bigint         not null,
    initial_compile_start_time      datetimeoffset not null,
    is_internal_query               bit            not null,
    last_bind_cpu_time              bigint         not null,
    last_bind_duration              bigint         not null,
    last_compile_batch_offset_end   bigint         not null,
    last_compile_batch_offset_start bigint         not null,
    last_compile_batch_sql_handle   varbinary(64),
    last_compile_duration           bigint         not null,
    last_compile_memory_kb          bigint         not null,
    last_compile_start_time         datetimeoffset not null,
    last_execution_time             datetimeoffset,
    last_optimize_cpu_time          bigint         not null,
    last_optimize_duration          bigint         not null,
    last_parse_cpu_time             bigint         not null,
    last_parse_duration             bigint         not null,
    max_compile_memory_kb           bigint         not null,
    object_id                       bigint,
    query_flags                     int,
    query_hash                      binary(8)      not null,
    query_id                        bigint         not null,
    query_param_type                tinyint        not null,
    query_text_id                   bigint         not null,
    statement_sql_handle            varbinary(64),
    status                          tinyint        not null,
    total_bind_cpu_time             bigint         not null,
    total_bind_duration             bigint         not null,
    total_compile_duration          bigint         not null,
    total_compile_memory_kb         bigint         not null,
    total_optimize_cpu_time         bigint         not null,
    total_optimize_duration         bigint         not null,
    total_parse_cpu_time            bigint         not null,
    total_parse_duration            bigint         not null
)
go

create unique clustered index plan_persist_query_cidx
    on sys.plan_persist_query (query_id)
go

create index plan_persist_query_idx1
    on sys.plan_persist_query (query_text_id, context_settings_id)
go

create table sys.plan_persist_query_hints
(
    batch_sql_handle               varbinary(64),
    comment                        nvarchar(max),
    context_settings_id            bigint        not null,
    last_query_hint_failure_reason int           not null,
    object_id                      bigint,
    query_hash                     binary(8)     not null,
    query_hint_failure_count       bigint        not null,
    query_hint_id                  bigint        not null,
    query_hints                    nvarchar(max),
    query_hints_flags              int,
    query_id                       bigint        not null,
    query_param_type               tinyint       not null,
    statement_sql_handle           varbinary(64) not null
)
go

create unique clustered index plan_persist_query_hints_cidx
    on sys.plan_persist_query_hints (query_hint_id)
go

create unique index plan_persist_query_hints_idx1
    on sys.plan_persist_query_hints (query_hint_id)
go

create table sys.plan_persist_query_template_parameterization
(
    comment                              nvarchar(max),
    last_parameterization_failure_reason int           not null,
    parameterization_failure_count       bigint        not null,
    query_param_type                     tinyint       not null,
    query_template                       nvarchar(max),
    query_template_flags                 int,
    query_template_hash                  varbinary(16) not null,
    query_template_id                    bigint        not null,
    status                               tinyint       not null
)
go

create unique clustered index plan_persist_query_template_parameterization_cidx
    on sys.plan_persist_query_template_parameterization (query_template_id)
go

create unique index plan_persist_query_template_parameterization_idx1
    on sys.plan_persist_query_template_parameterization (query_template_hash)
go

create table sys.plan_persist_query_text
(
    has_restricted_text         bit           not null,
    is_part_of_encrypted_module bit           not null,
    query_sql_text              nvarchar(max),
    query_template_hash         varbinary(16),
    query_text_id               bigint        not null,
    statement_sql_handle        varbinary(64) not null
)
go

create unique clustered index plan_persist_query_text_cidx
    on sys.plan_persist_query_text (query_text_id)
go

create unique index plan_persist_query_text_idx1
    on sys.plan_persist_query_text (statement_sql_handle)
go

create table sys.plan_persist_runtime_stats
(
    count_executions                bigint         not null,
    execution_type                  tinyint        not null,
    first_execution_time            datetimeoffset not null,
    last_clr_time                   bigint         not null,
    last_cpu_time                   bigint         not null,
    last_dop                        bigint         not null,
    last_duration                   bigint         not null,
    last_execution_time             datetimeoffset not null,
    last_log_bytes_used             bigint,
    last_logical_io_reads           bigint         not null,
    last_logical_io_writes          bigint         not null,
    last_num_physical_io_reads      bigint,
    last_physical_io_reads          bigint         not null,
    last_query_max_used_memory      bigint         not null,
    last_rowcount                   bigint         not null,
    last_tempdb_space_used          bigint,
    max_clr_time                    bigint         not null,
    max_cpu_time                    bigint         not null,
    max_dop                         bigint         not null,
    max_duration                    bigint         not null,
    max_log_bytes_used              bigint,
    max_logical_io_reads            bigint         not null,
    max_logical_io_writes           bigint         not null,
    max_num_physical_io_reads       bigint,
    max_physical_io_reads           bigint         not null,
    max_query_max_used_memory       bigint         not null,
    max_rowcount                    bigint         not null,
    max_tempdb_space_used           bigint,
    min_clr_time                    bigint         not null,
    min_cpu_time                    bigint         not null,
    min_dop                         bigint         not null,
    min_duration                    bigint         not null,
    min_log_bytes_used              bigint,
    min_logical_io_reads            bigint         not null,
    min_logical_io_writes           bigint         not null,
    min_num_physical_io_reads       bigint,
    min_physical_io_reads           bigint         not null,
    min_query_max_used_memory       bigint         not null,
    min_rowcount                    bigint         not null,
    min_tempdb_space_used           bigint,
    plan_id                         bigint         not null,
    runtime_stats_id                bigint         not null,
    runtime_stats_interval_id       bigint         not null,
    sumsquare_clr_time              float          not null,
    sumsquare_cpu_time              float          not null,
    sumsquare_dop                   float          not null,
    sumsquare_duration              float          not null,
    sumsquare_log_bytes_used        float,
    sumsquare_logical_io_reads      float          not null,
    sumsquare_logical_io_writes     float          not null,
    sumsquare_num_physical_io_reads float,
    sumsquare_physical_io_reads     float          not null,
    sumsquare_query_max_used_memory float          not null,
    sumsquare_rowcount              float          not null,
    sumsquare_tempdb_space_used     float,
    total_clr_time                  bigint         not null,
    total_cpu_time                  bigint         not null,
    total_dop                       bigint         not null,
    total_duration                  bigint         not null,
    total_log_bytes_used            bigint,
    total_logical_io_reads          bigint         not null,
    total_logical_io_writes         bigint         not null,
    total_num_physical_io_reads     bigint,
    total_physical_io_reads         bigint         not null,
    total_query_max_used_memory     bigint         not null,
    total_rowcount                  bigint         not null,
    total_tempdb_space_used         bigint
)
go

create unique clustered index plan_persist_runtime_stats_cidx
    on sys.plan_persist_runtime_stats (plan_id, runtime_stats_interval_id, execution_type)
go

create unique index plan_persist_runtime_stats_idx1
    on sys.plan_persist_runtime_stats (runtime_stats_id)
go

create table sys.plan_persist_runtime_stats_interval
(
    comment                   nvarchar(max),
    end_time                  datetimeoffset not null,
    runtime_stats_interval_id bigint         not null,
    start_time                datetimeoffset not null
)
go

create unique clustered index plan_persist_runtime_stats_interval_cidx
    on sys.plan_persist_runtime_stats_interval (runtime_stats_interval_id)
go

create index plan_persist_runtime_stats_interval_idx1
    on sys.plan_persist_runtime_stats_interval (end_time)
go

create table sys.plan_persist_wait_stats
(
    count_executions             bigint   not null,
    execution_type               tinyint  not null,
    last_query_wait_time_ms      bigint   not null,
    max_query_wait_time_ms       bigint   not null,
    min_query_wait_time_ms       bigint   not null,
    plan_id                      bigint   not null,
    runtime_stats_interval_id    bigint   not null,
    sumsquare_query_wait_time_ms float    not null,
    total_query_wait_time_ms     bigint   not null,
    wait_category                smallint not null,
    wait_stats_id                bigint   not null
)
go

create unique clustered index plan_persist_wait_stats_cidx
    on sys.plan_persist_wait_stats (runtime_stats_interval_id, plan_id, wait_category, execution_type)
go

create unique index plan_persist_wait_stats_idx1
    on sys.plan_persist_wait_stats (wait_stats_id)
go

create table sys.queue_messages_1977058079
(
    binary_message_body     varbinary(max),
    conversation_group_id   uniqueidentifier not null,
    conversation_handle     uniqueidentifier not null,
    fragment_bitmap         bigint           not null,
    fragment_size           int              not null,
    message_enqueue_time    datetime,
    message_id              uniqueidentifier not null,
    message_sequence_number bigint           not null,
    message_type_id         int              not null,
    next_fragment           int              not null,
    priority                tinyint          not null,
    queuing_order           bigint identity (0, 1),
    service_contract_id     int              not null,
    service_id              int              not null,
    status                  tinyint          not null,
    validation              nchar(1)         not null
)
go

create unique clustered index queue_clustered_index
    on sys.queue_messages_1977058079 (status, priority, queuing_order, conversation_group_id, conversation_handle)
go

create unique index queue_secondary_index
    on sys.queue_messages_1977058079 (status, priority, queuing_order, conversation_group_id, conversation_handle,
                                      service_id)
go

create table sys.queue_messages_2009058193
(
    binary_message_body     varbinary(max),
    conversation_group_id   uniqueidentifier not null,
    conversation_handle     uniqueidentifier not null,
    fragment_bitmap         bigint           not null,
    fragment_size           int              not null,
    message_enqueue_time    datetime,
    message_id              uniqueidentifier not null,
    message_sequence_number bigint           not null,
    message_type_id         int              not null,
    next_fragment           int              not null,
    priority                tinyint          not null,
    queuing_order           bigint identity (0, 1),
    service_contract_id     int              not null,
    service_id              int              not null,
    status                  tinyint          not null,
    validation              nchar(1)         not null
)
go

create unique clustered index queue_clustered_index
    on sys.queue_messages_2009058193 (status, priority, queuing_order, conversation_group_id, conversation_handle)
go

create unique index queue_secondary_index
    on sys.queue_messages_2009058193 (status, priority, queuing_order, conversation_group_id, conversation_handle,
                                      service_id)
go

create table sys.queue_messages_2041058307
(
    binary_message_body     varbinary(max),
    conversation_group_id   uniqueidentifier not null,
    conversation_handle     uniqueidentifier not null,
    fragment_bitmap         bigint           not null,
    fragment_size           int              not null,
    message_enqueue_time    datetime,
    message_id              uniqueidentifier not null,
    message_sequence_number bigint           not null,
    message_type_id         int              not null,
    next_fragment           int              not null,
    priority                tinyint          not null,
    queuing_order           bigint identity (0, 1),
    service_contract_id     int              not null,
    service_id              int              not null,
    status                  tinyint          not null,
    validation              nchar(1)         not null
)
go

create unique clustered index queue_clustered_index
    on sys.queue_messages_2041058307 (status, priority, queuing_order, conversation_group_id, conversation_handle)
go

create unique index queue_secondary_index
    on sys.queue_messages_2041058307 (status, priority, queuing_order, conversation_group_id, conversation_handle,
                                      service_id)
go

create table sys.sqlagent_job_history
(
    instance_id         int identity,
    job_id              uniqueidentifier not null,
    message             nvarchar(4000),
    operator_id_emailed int              not null,
    operator_id_paged   int              not null,
    retries_attempted   int              not null,
    run_date            int              not null,
    run_duration        int              not null,
    run_status          int              not null,
    run_time            int              not null,
    sql_message_id      int              not null,
    sql_severity        int              not null,
    step_id             int              not null
)
go

create unique clustered index sqlagent_job_history_clust
    on sys.sqlagent_job_history (instance_id)
go

create index sqlagent_job_history_nc1
    on sys.sqlagent_job_history (job_id)
go

create table sys.sqlagent_jobs
(
    date_created          datetime         not null,
    date_modified         datetime         not null,
    delete_level          int              not null,
    description           nvarchar(512),
    enabled               bit              not null,
    job_id                uniqueidentifier not null,
    name                  sysname          not null,
    notify_level_eventlog bit              not null,
    start_step_id         int              not null
)
go

create unique clustered index sqlagent_jobs_clust
    on sys.sqlagent_jobs (job_id)
go

create index sqlagent_jobs_nc1_name
    on sys.sqlagent_jobs (name)
go

create table sys.sqlagent_jobsteps
(
    additional_parameters nvarchar(max),
    cmdexec_success_code  int              not null,
    command               nvarchar(max),
    database_name         sysname,
    database_user_name    sysname,
    flags                 int              not null,
    job_id                uniqueidentifier not null,
    last_run_date         int              not null,
    last_run_duration     int              not null,
    last_run_outcome      int              not null,
    last_run_retries      int              not null,
    last_run_time         int              not null,
    on_fail_action        tinyint          not null,
    on_fail_step_id       int              not null,
    on_success_action     tinyint          not null,
    on_success_step_id    int              not null,
    os_run_priority       int              not null,
    output_file_name      nvarchar(200),
    retry_attempts        int              not null,
    retry_interval        int              not null,
    server                sysname,
    step_id               int              not null,
    step_name             sysname          not null,
    step_uid              uniqueidentifier not null,
    subsystem             nvarchar(40)     not null
)
go

create unique clustered index sqlagent_jobsteps_clust
    on sys.sqlagent_jobsteps (job_id, step_id)
go

create unique index sqlagent_jobsteps_nc1
    on sys.sqlagent_jobsteps (job_id, step_name)
go

create unique index sqlagent_jobsteps_nc2
    on sys.sqlagent_jobsteps (step_uid)
go

create table sys.sqlagent_jobsteps_logs
(
    date_created datetime         not null,
    log_id       int identity,
    log_text     nvarchar(max)    not null,
    step_uid     uniqueidentifier not null
)
go

create index sqlagent_jobsteps_logs_nc1
    on sys.sqlagent_jobsteps_logs (step_uid, date_created)
go

create table sys.sysallocunits
(
    auid       bigint    not null,
    fgid       smallint  not null,
    ownerid    bigint    not null,
    pcdata     bigint    not null,
    pcreserved bigint    not null,
    pcused     bigint    not null,
    pgfirst    binary(6) not null,
    pgfirstiam binary(6) not null,
    pgroot     binary(6) not null,
    status     int       not null,
    type       tinyint   not null
)
go

create unique clustered index clust
    on sys.sysallocunits (auid)
go

create unique index nc
    on sys.sysallocunits (ownerid, type, auid)
go

create table sys.sysasymkeys
(
    algorithm  char(2)        not null,
    bitlength  int            not null,
    encrtype   char(2)        not null,
    id         int            not null,
    modified   datetime       not null,
    name       sysname        not null,
    pkey       varbinary(4700),
    pukey      varbinary(max) not null,
    thumbprint varbinary(64)  not null
)
go

create unique clustered index cl
    on sys.sysasymkeys (id)
go

create unique index nc1
    on sys.sysasymkeys (name)
go

create unique index nc3
    on sys.sysasymkeys (thumbprint)
go

create table sys.sysaudacts
(
    audit_spec_id int     not null,
    class         tinyint not null,
    grantee       int     not null,
    id            int     not null,
    state         char    not null,
    subid         int     not null,
    type          char(4) not null
)
go

create unique clustered index clust
    on sys.sysaudacts (class, id, subid, grantee, audit_spec_id, type)
go

create table sys.sysbinobjs
(
    class    tinyint  not null,
    created  datetime not null,
    id       int      not null,
    intprop  int      not null,
    modified datetime not null,
    name     sysname  not null,
    nsid     int      not null,
    status   int      not null,
    type     char(2)  not null
)
go

create unique clustered index clst
    on sys.sysbinobjs (class, id)
go

create unique index nc1
    on sys.sysbinobjs (class, nsid, name)
go

create table sys.sysbinsubobjs
(
    class   tinyint not null,
    idmajor int     not null,
    intprop int     not null,
    name    sysname not null,
    status  int     not null,
    subid   int     not null
)
go

create unique clustered index clst
    on sys.sysbinsubobjs (class, idmajor, subid)
go

create unique index nc1
    on sys.sysbinsubobjs (name, idmajor, class)
go

create table sys.sysbrickfiles
(
    backuplsn         binary(10),
    brickid           int           not null,
    createlsn         binary(10),
    dbid              int           not null,
    diffbaseguid      uniqueidentifier,
    diffbaselsn       binary(10),
    diffbaseseclsn    binary(10),
    diffbasetime      datetime      not null,
    droplsn           binary(10),
    fileguid          uniqueidentifier,
    fileid            int           not null,
    filestate         tinyint       not null,
    filetype          tinyint       not null,
    firstupdatelsn    binary(10),
    forkguid          uniqueidentifier,
    forklsn           binary(10),
    forkvc            bigint        not null,
    growth            int           not null,
    grpid             int           not null,
    internalstatus    int           not null,
    lastupdatelsn     binary(10),
    lname             sysname       not null,
    maxsize           int           not null,
    pname             nvarchar(260) not null,
    pruid             int           not null,
    readonlybaselsn   binary(10),
    readonlylsn       binary(10),
    readwritelsn      binary(10),
    redostartforkguid uniqueidentifier,
    redostartlsn      binary(10),
    redotargetlsn     binary(10),
    size              int           not null,
    status            int           not null
)
go

create unique clustered index clst
    on sys.sysbrickfiles (dbid, pruid, fileid)
go

create table sys.syscerts
(
    cert           varbinary(max) not null,
    encrtype       char(2)        not null,
    id             int            not null,
    issuer         varbinary(884) not null,
    lastpkeybackup datetime,
    name           sysname        not null,
    pkey           varbinary(4700),
    snum           varbinary(32)  not null,
    status         int            not null,
    thumbprint     varbinary(64)  not null
)
go

create unique clustered index cl
    on sys.syscerts (id)
go

create unique index nc1
    on sys.syscerts (name)
go

create unique index nc2
    on sys.syscerts (issuer, snum)
go

create unique index nc3
    on sys.syscerts (thumbprint)
go

create table sys.syschildinsts
(
    crdate    datetime      not null,
    iname     sysname       not null,
    ipipename nvarchar(260) not null,
    lsid      varbinary(85) not null,
    modate    datetime      not null,
    pid       int           not null,
    status    int           not null,
    sysdbpath nvarchar(260) not null
)
go

create unique clustered index cl
    on sys.syschildinsts (lsid)
go

create table sys.sysclones
(
    cloneid  int    not null,
    dbfragid int    not null,
    id       int    not null,
    partid   int    not null,
    rowsetid bigint not null,
    segid    int    not null,
    status   int    not null,
    subid    int    not null,
    version  int    not null
)
go

create unique clustered index clst
    on sys.sysclones (id, subid, partid, version, segid, cloneid)
go

create table sys.sysclsobjs
(
    class    tinyint  not null,
    created  datetime not null,
    id       int      not null,
    intprop  int      not null,
    modified datetime not null,
    name     sysname  not null,
    status   int      not null,
    type     char(2)  not null
)
go

create unique clustered index clst
    on sys.sysclsobjs (class, id)
go

create unique index nc
    on sys.sysclsobjs (name, class)
go

create table sys.syscolpars
(
    chk         int      not null,
    colid       int      not null,
    collationid int      not null,
    dflt        int      not null,
    id          int      not null,
    idtval      varbinary(64),
    length      smallint not null,
    maxinrow    smallint not null,
    name        sysname,
    number      smallint not null,
    prec        tinyint  not null,
    scale       tinyint  not null,
    status      int      not null,
    utype       int      not null,
    xmlns       int      not null,
    xtype       tinyint  not null
)
go

create unique clustered index clst
    on sys.syscolpars (id, number, colid)
go

create unique index nc
    on sys.syscolpars (id, name, number)
go

create table sys.syscommittab
(
    commit_csn  bigint   not null,
    commit_lbn  bigint   not null,
    commit_time datetime not null,
    commit_ts   bigint   not null,
    dbfragid    int      not null,
    xdes_id     bigint   not null
)
go

create unique clustered index ci_commit_ts
    on sys.syscommittab (commit_ts, xdes_id)
go

create unique index si_xdes_id
    on sys.syscommittab (xdes_id) include (dbfragid)
go

create table sys.syscompfragments
(
    cprelid   int       not null,
    datasize  bigint    not null,
    fragid    int       not null,
    fragobjid int       not null,
    itemcnt   bigint    not null,
    rowcnt    bigint    not null,
    status    int       not null,
    ts        binary(8) not null
)
go

create unique clustered index clst
    on sys.syscompfragments (cprelid, fragid)
go

create table sys.sysconvgroup
(
    id         uniqueidentifier not null,
    refcount   int              not null,
    service_id int              not null,
    status     int              not null
)
go

create unique clustered index clst
    on sys.sysconvgroup (id)
go

create table sys.syscscolsegments
(
    base_id                 bigint     not null,
    column_id               int        not null,
    container_id            smallint,
    data_ptr                binary(16) not null,
    encoding_type           int        not null,
    hobt_id                 bigint     not null,
    magnitude               float      not null,
    max_data_id             bigint     not null,
    min_data_id             bigint     not null,
    null_value              bigint     not null,
    on_disk_size            bigint     not null,
    primary_dictionary_id   int        not null,
    row_count               int        not null,
    secondary_dictionary_id int        not null,
    segment_id              int        not null,
    status                  int        not null,
    version                 int        not null
)
go

create unique clustered index clust
    on sys.syscscolsegments (hobt_id, column_id, segment_id)
go

create table sys.syscsdictionaries
(
    column_id     int        not null,
    container_id  smallint,
    data_ptr      binary(16) not null,
    dictionary_id int        not null,
    entry_count   bigint     not null,
    flags         bigint     not null,
    hobt_id       bigint     not null,
    last_id       int        not null,
    on_disk_size  bigint     not null,
    type          int        not null,
    version       int        not null
)
go

create unique clustered index clust
    on sys.syscsdictionaries (hobt_id, column_id, dictionary_id)
go

create table sys.syscsrowgroups
(
    closed_time       datetime,
    compressed_reason int    not null,
    created_time      datetime,
    ds_hobtid         bigint,
    flags             int    not null,
    generation        bigint not null,
    hobt_id           bigint not null,
    row_count         int    not null,
    segment_id        int    not null,
    status            int    not null,
    version           int    not null
)
go

create unique clustered index clust
    on sys.syscsrowgroups (hobt_id, segment_id)
go

create table sys.sysdbfiles
(
    dbfragid int              not null,
    fileguid uniqueidentifier not null,
    fileid   int              not null,
    pname    nvarchar(260)
)
go

create unique clustered index clst
    on sys.sysdbfiles (dbfragid, fileid)
go

create table sys.sysdbfrag
(
    brickid int     not null,
    dbid    int     not null,
    fragid  int     not null,
    name    sysname not null,
    pruid   int     not null,
    status  int     not null
)
go

create unique clustered index cl
    on sys.sysdbfrag (dbid, fragid)
go

create unique index nc1
    on sys.sysdbfrag (dbid, brickid, pruid)
go

create table sys.sysdbreg
(
    category    int              not null,
    cmptlevel   tinyint          not null,
    crdate      datetime         not null,
    id          int              not null,
    modified    datetime         not null,
    name        sysname          not null,
    scope       int              not null,
    sid         varbinary(85),
    status      int              not null,
    status2     int              not null,
    svcbrkrguid uniqueidentifier not null
)
go

create unique clustered index clst
    on sys.sysdbreg (id)
go

create unique index nc1
    on sys.sysdbreg (name)
go

create unique index nc2
    on sys.sysdbreg (svcbrkrguid, scope)
go

create table sys.sysdercv
(
    contract     int              not null,
    convgroup    uniqueidentifier not null,
    diagid       uniqueidentifier not null,
    dlgopened    datetime         not null,
    dlgtimer     datetime         not null,
    enddlgseq    bigint           not null,
    farbrkrinst  nvarchar(128),
    farprincid   int              not null,
    farsvc       nvarchar(256)    not null,
    firstoorder  bigint           not null,
    handle       uniqueidentifier not null,
    initiator    tinyint          not null,
    inseskey     varbinary(4096)  not null,
    inseskeyid   uniqueidentifier not null,
    lastoorder   bigint           not null,
    lastoorderfr int              not null,
    lifetime     datetime         not null,
    outseskey    varbinary(4096)  not null,
    outseskeyid  uniqueidentifier not null,
    princid      int              not null,
    priority     tinyint          not null,
    rcvfrag      int              not null,
    rcvseq       bigint           not null,
    state        char(2)          not null,
    status       int              not null,
    svcid        int              not null,
    sysseq       bigint           not null
)
go

create unique clustered index cl
    on sys.sysdercv (diagid, initiator)
go

create table sys.sysdesend
(
    diagid    uniqueidentifier not null,
    handle    uniqueidentifier not null,
    initiator tinyint          not null,
    sendseq   bigint           not null,
    sendxact  binary(6)        not null
)
go

create unique clustered index cl
    on sys.sysdesend (handle)
go

create table sys.sysendpts
(
    affinity  bigint   not null,
    authrealm nvarchar(128),
    authtype  tinyint  not null,
    bstat     smallint not null,
    dfltdb    sysname,
    dfltdm    nvarchar(128),
    dfltns    nvarchar(384),
    encalg    tinyint  not null,
    id        int      not null,
    maxconn   int      not null,
    name      sysname  not null,
    port1     int      not null,
    port2     int      not null,
    protocol  tinyint  not null,
    pstat     smallint not null,
    site      nvarchar(128),
    tstat     smallint not null,
    type      tinyint  not null,
    typeint   int      not null,
    wsdlproc  nvarchar(776)
)
go

create unique clustered index clst
    on sys.sysendpts (id)
go

create unique index nc1
    on sys.sysendpts (name)
go

create table sys.sysextfileformats
(
    data_compression nvarchar(255),
    date_format      nvarchar(50),
    encoding         nvarchar(10),
    field_terminator nvarchar(10),
    file_format_id   int           not null,
    format_type      nvarchar(100) not null,
    name             nvarchar(128) not null,
    row_terminator   nvarchar(10),
    serde_method     nvarchar(255),
    string_delimiter nvarchar(10),
    use_type_default int           not null
)
go

create unique clustered index clidx1
    on sys.sysextfileformats (file_format_id)
go

create unique index ncidx1
    on sys.sysextfileformats (name)
go

create table sys.sysextsources
(
    credential_id        int            not null,
    data_source_id       int            not null,
    job_tracker_location nvarchar(4000),
    location             nvarchar(4000) not null,
    name                 nvarchar(128)  not null,
    shard_map_manager_db nvarchar(128),
    shard_map_name       nvarchar(128),
    storage_key          nvarchar(4000),
    type                 tinyint        not null,
    type_desc            nvarchar(255)  not null,
    user_name            nvarchar(128)
)
go

create unique clustered index clidx1
    on sys.sysextsources (data_source_id)
go

create unique index ncidx1
    on sys.sysextsources (name)
go

create table sys.sysexttables
(
    data_source_id      int     not null,
    file_format_id      int,
    location            nvarchar(4000),
    object_id           int     not null,
    reject_sample_value float,
    reject_type         nvarchar(20),
    reject_value        float,
    sharding_col_id     int     not null,
    sharding_dist_type  tinyint not null,
    source_schema_name  nvarchar(128),
    source_table_name   nvarchar(128)
)
go

create unique clustered index clidx1
    on sys.sysexttables (object_id)
go

create table sys.sysfgfrag
(
    dbfragid int not null,
    fgfragid int not null,
    fgid     int not null,
    phfgid   int not null,
    status   int not null
)
go

create unique clustered index cl
    on sys.sysfgfrag (fgid, fgfragid, dbfragid, phfgid)
go

create table sys.sysfiles1
(
    fileid   smallint   not null,
    filename nchar(260) not null,
    name     nchar(128) not null,
    status   int        not null
)
go

create table sys.sysfoqueues
(
    created datetime   not null,
    csn     bigint,
    epoch   int,
    id      int        not null,
    lsn     binary(10) not null
)
go

create unique clustered index clst
    on sys.sysfoqueues (id, lsn)
go

create table sys.sysfos
(
    created  datetime       not null,
    csn      bigint,
    epoch    int,
    high     varbinary(512),
    history  varbinary(6000),
    id       int            not null,
    low      varbinary(512) not null,
    modified datetime       not null,
    rowcnt   bigint,
    size     bigint,
    status   char           not null,
    tgid     int            not null
)
go

create unique clustered index clst
    on sys.sysfos (id)
go

create unique index nc1
    on sys.sysfos (tgid, low, high)
go

create table sys.sysftinds
(
    bXVTDocidUseBaseT tinyint   not null,
    batchsize         int       not null,
    crend             datetime,
    crerrors          int       not null,
    crrows            bigint    not null,
    crschver          binary(8) not null,
    crstart           datetime,
    crtsnext          binary(8),
    crtype            char      not null,
    fgid              int       not null,
    id                int       not null,
    indid             int       not null,
    nextdocid         bigint    not null,
    sensitivity       tinyint   not null,
    status            int       not null
)
go

create unique clustered index clst
    on sys.sysftinds (id)
go

create table sys.sysftproperties
(
    guid_identifier    uniqueidentifier not null,
    int_identifier     int              not null,
    property_id        int              not null,
    property_list_id   int              not null,
    property_name      nvarchar(256)    not null,
    string_description nvarchar(512)
)
go

create unique clustered index clst
    on sys.sysftproperties (property_list_id, property_id)
go

create unique index nonclst
    on sys.sysftproperties (property_list_id, property_name)
go

create unique index nonclstgi
    on sys.sysftproperties (property_list_id, guid_identifier, int_identifier)
go

create table sys.sysftsemanticsdb
(
    database_id   int              not null,
    fileguid      uniqueidentifier not null,
    register_date datetime         not null,
    registered_by int              not null,
    version       nvarchar(128)    not null
)
go

create unique clustered index cl
    on sys.sysftsemanticsdb (database_id)
go

create table sys.sysftstops
(
    lcid       int          not null,
    status     tinyint      not null,
    stoplistid int          not null,
    stopword   nvarchar(64) not null
)
go

create unique clustered index clst
    on sys.sysftstops (stoplistid, stopword, lcid)
go

create table sys.sysguidrefs
(
    class  tinyint          not null,
    guid   uniqueidentifier not null,
    id     int              not null,
    status int              not null,
    subid  int              not null
)
go

create unique clustered index cl
    on sys.sysguidrefs (class, id, subid)
go

create unique index nc
    on sys.sysguidrefs (guid, class)
go

create table sys.sysidxstats
(
    dataspace int     not null,
    fillfact  tinyint not null,
    id        int     not null,
    indid     int     not null,
    intprop   int     not null,
    lobds     int     not null,
    name      sysname,
    rowset    bigint  not null,
    status    int     not null,
    tinyprop  tinyint not null,
    type      tinyint not null
)
go

create unique clustered index clst
    on sys.sysidxstats (id, indid)
go

create unique index nc
    on sys.sysidxstats (name, id)
go

create table sys.sysiscols
(
    idmajor   int     not null,
    idminor   int     not null,
    intprop   int     not null,
    status    int     not null,
    subid     int     not null,
    tinyprop1 tinyint not null,
    tinyprop2 tinyint not null,
    tinyprop3 tinyint not null,
    tinyprop4 tinyint not null
)
go

create unique clustered index clst
    on sys.sysiscols (idmajor, idminor, subid)
go

create unique index nc1
    on sys.sysiscols (idmajor, intprop, subid, idminor)
go

create table sys.syslnklgns
(
    lgnid   int,
    modate  datetime not null,
    name    sysname,
    pwdhash varbinary(320),
    srvid   int      not null,
    status  int      not null
)
go

create unique clustered index cl
    on sys.syslnklgns (srvid, lgnid)
go

create table sys.sysmultiobjrefs
(
    class      tinyint not null,
    depid      int     not null,
    depsubid   int     not null,
    indepid    int     not null,
    indepsubid int     not null,
    status     int     not null
)
go

create unique clustered index clst
    on sys.sysmultiobjrefs (class, depid, depsubid, indepid, indepsubid)
go

create unique index nc1
    on sys.sysmultiobjrefs (indepid, class, indepsubid, depid, depsubid)
go

create table sys.sysmultiobjvalues
(
    depid      int     not null,
    depsubid   int     not null,
    imageval   varbinary(max),
    indepid    int     not null,
    indepsubid int     not null,
    valclass   tinyint not null,
    valnum     int     not null,
    value      sql_variant
)
go

create unique clustered index clust
    on sys.sysmultiobjvalues (valclass, depid, depsubid, indepid, indepsubid, valnum)
go

create unique index nc1
    on sys.sysmultiobjvalues (valclass, indepid, indepsubid, depid, depsubid, valnum)
go

create table sys.sysnsobjs
(
    class    tinyint  not null,
    created  datetime not null,
    id       int      not null,
    intprop  int      not null,
    modified datetime not null,
    name     sysname  not null,
    nsid     int      not null,
    status   int      not null
)
go

create unique clustered index clst
    on sys.sysnsobjs (class, id)
go

create unique index nc
    on sys.sysnsobjs (name, nsid, class)
go

create table sys.sysobjkeycrypts
(
    class      tinyint        not null,
    crypto     varbinary(max) not null,
    id         int            not null,
    status     int            not null,
    thumbprint varbinary(32)  not null,
    type       char(4)        not null
)
go

create unique clustered index cl
    on sys.sysobjkeycrypts (class, id, thumbprint)
go

create table sys.sysobjvalues
(
    imageval varbinary(max),
    objid    int     not null,
    subobjid int     not null,
    valclass tinyint not null,
    valnum   int     not null,
    value    sql_variant
)
go

create unique clustered index clst
    on sys.sysobjvalues (valclass, objid, subobjid, valnum)
go

create table sys.sysowners
(
    created     datetime not null,
    deflanguage sysname,
    dfltsch     sysname,
    id          int      not null,
    modified    datetime not null,
    name        sysname  not null,
    password    varbinary(256),
    sid         varbinary(85),
    status      int      not null,
    type        char     not null
)
go

create unique clustered index clst
    on sys.sysowners (id)
go

create unique index nc1
    on sys.sysowners (name)
go

create unique index nc2
    on sys.sysowners (sid, id)
go

create table sys.sysphfg
(
    dbfragid int     not null,
    fgguid   uniqueidentifier,
    fgid     int     not null,
    lgfgid   int,
    name     sysname not null,
    phfgid   int     not null,
    status   int     not null,
    type     char(2) not null
)
go

create unique clustered index cl
    on sys.sysphfg (phfgid)
go

create table sys.syspriorities
(
    local_service_id    int,
    name                sysname not null,
    priority            tinyint not null,
    priority_id         int     not null,
    remote_service_name nvarchar(256),
    service_contract_id int
)
go

create unique clustered index cl
    on sys.syspriorities (priority_id)
go

create unique index nc
    on sys.syspriorities (service_contract_id, local_service_id, remote_service_name) include (priority)
go

create unique index nc2
    on sys.syspriorities (name)
go

create table sys.sysprivs
(
    class   tinyint not null,
    grantee int     not null,
    grantor int     not null,
    id      int     not null,
    state   char    not null,
    subid   int     not null,
    type    char(4) not null
)
go

create unique clustered index clust
    on sys.sysprivs (class, id, subid, grantee, grantor, type)
go

create table sys.syspru
(
    brickid int not null,
    dbid    int not null,
    fragid  int not null,
    pruid   int not null,
    status  int not null
)
go

create unique clustered index cl
    on sys.syspru (dbid, pruid)
go

create table sys.sysprufiles
(
    backuplsn         binary(10),
    createlsn         binary(10),
    dbfragid          int           not null,
    diffbaseguid      uniqueidentifier,
    diffbaselsn       binary(10),
    diffbaseseclsn    binary(10),
    diffbasetime      datetime      not null,
    droplsn           binary(10),
    fileguid          uniqueidentifier,
    fileid            int           not null,
    filestate         tinyint       not null,
    filetype          tinyint       not null,
    firstupdatelsn    binary(10),
    forkguid          uniqueidentifier,
    forklsn           binary(10),
    forkvc            bigint        not null,
    growth            int           not null,
    grpid             int           not null,
    internalstatus    int           not null,
    lastupdatelsn     binary(10),
    lname             sysname       not null,
    maxsize           int           not null,
    pname             nvarchar(260) not null,
    readonlybaselsn   binary(10),
    readonlylsn       binary(10),
    readwritelsn      binary(10),
    redostartforkguid uniqueidentifier,
    redostartlsn      binary(10),
    redotargetlsn     binary(10),
    size              int           not null,
    status            int           not null
)
go

create unique clustered index clst
    on sys.sysprufiles (fileid)
go

create table sys.sysqnames
(
    hash int            not null,
    name nvarchar(4000) not null,
    nid  int            not null,
    qid  int            not null
)
go

create unique clustered index clst
    on sys.sysqnames (qid, hash, nid)
go

create unique index nc1
    on sys.sysqnames (nid)
go

create table sys.sysremsvcbinds
(
    id     int     not null,
    name   sysname not null,
    remsvc nvarchar(256),
    scid   int     not null,
    status int     not null
)
go

create unique clustered index clst
    on sys.sysremsvcbinds (id)
go

create unique index nc1
    on sys.sysremsvcbinds (name)
go

create unique index nc2
    on sys.sysremsvcbinds (scid, remsvc)
go

create table sys.sysrmtlgns
(
    lgnid  int,
    modate datetime not null,
    name   sysname,
    srvid  int      not null,
    status int      not null
)
go

create unique clustered index cl
    on sys.sysrmtlgns (srvid, name)
go

create table sys.sysrowsetrefs
(
    class     tinyint not null,
    indexid   int     not null,
    objid     int     not null,
    rowsetid  bigint  not null,
    rowsetnum int     not null,
    status    int     not null
)
go

create unique clustered index clust
    on sys.sysrowsetrefs (class, objid, indexid, rowsetnum)
go

create table sys.sysrowsets
(
    cmprlevel  tinyint  not null,
    fgidfs     smallint not null,
    fillfact   tinyint  not null,
    idmajor    int      not null,
    idminor    int      not null,
    lockres    varbinary(8),
    maxint     smallint not null,
    maxleaf    int      not null,
    maxnullbit smallint not null,
    minint     smallint not null,
    minleaf    smallint not null,
    numpart    int      not null,
    ownertype  tinyint  not null,
    rcrows     bigint   not null,
    rowsetid   bigint   not null,
    rsguid     varbinary(16),
    scope_id   int,
    status     int      not null
)
go

create unique clustered index clust
    on sys.sysrowsets (rowsetid)
go

create table sys.sysrscols
(
    bitpos      smallint not null,
    cid         int      not null,
    colguid     varbinary(16),
    hbcolid     int      not null,
    maxinrowlen smallint not null,
    nullbit     int      not null,
    offset      int      not null,
    ordkey      smallint not null,
    rcmodified  bigint   not null,
    rscolid     int      not null,
    rsid        bigint   not null,
    status      int      not null,
    ti          int      not null
)
go

create unique clustered index clst
    on sys.sysrscols (rsid, hbcolid)
go

create table sys.sysrts
(
    addr     nvarchar(256),
    brkrinst nvarchar(128),
    id       int     not null,
    lifetime datetime,
    miraddr  nvarchar(256),
    name     sysname not null,
    remsvc   nvarchar(256)
)
go

create unique clustered index clst
    on sys.sysrts (id)
go

create unique index nc1
    on sys.sysrts (remsvc, brkrinst, id)
go

create unique index nc2
    on sys.sysrts (name)
go

create table sys.sysscalartypes
(
    chk         int      not null,
    collationid int      not null,
    created     datetime not null,
    dflt        int      not null,
    id          int      not null,
    length      smallint not null,
    modified    datetime not null,
    name        sysname  not null,
    prec        tinyint  not null,
    scale       tinyint  not null,
    schid       int      not null,
    status      int      not null,
    xtype       tinyint  not null
)
go

create unique clustered index clst
    on sys.sysscalartypes (id)
go

create unique index nc1
    on sys.sysscalartypes (schid, name)
go

create unique index nc2
    on sys.sysscalartypes (name, schid)
go

create table sys.sysschobjs
(
    created  datetime not null,
    id       int      not null,
    intprop  int      not null,
    modified datetime not null,
    name     sysname  not null,
    nsclass  tinyint  not null,
    nsid     int      not null,
    pclass   tinyint  not null,
    pid      int      not null,
    status   int      not null,
    status2  int      not null,
    type     char(2)  not null
)
go

create unique clustered index clst
    on sys.sysschobjs (id)
go

create unique index nc1
    on sys.sysschobjs (nsclass, nsid, name)
go

create unique index nc2
    on sys.sysschobjs (name, nsid, nsclass)
go

create index nc3
    on sys.sysschobjs (pid, pclass)
go

create table sys.sysseobjvalues
(
    id       bigint  not null,
    imageval varbinary(max),
    subid    bigint  not null,
    valclass tinyint not null,
    valnum   int     not null,
    value    sql_variant
)
go

create unique clustered index clst
    on sys.sysseobjvalues (valclass, id, subid, valnum)
go

create table sys.syssingleobjrefs
(
    class      tinyint not null,
    depid      int     not null,
    depsubid   int     not null,
    indepid    int     not null,
    indepsubid int     not null,
    status     int     not null
)
go

create unique clustered index clst
    on sys.syssingleobjrefs (class, depid, depsubid)
go

create unique index nc1
    on sys.syssingleobjrefs (indepid, class, indepsubid, depid, depsubid)
go

create table sys.syssoftobjrefs
(
    depclass    tinyint not null,
    depid       int     not null,
    indepclass  tinyint not null,
    indepdb     sysname,
    indepname   sysname not null,
    indepschema sysname,
    indepserver sysname,
    number      int     not null,
    status      int     not null
)
go

create unique clustered index clst
    on sys.syssoftobjrefs (depclass, depid, indepclass, indepname, indepschema, number)
go

create unique index nc1
    on sys.syssoftobjrefs (indepname, indepschema, indepclass, depid, depclass, number)
go

create table sys.syssqlguides
(
    batchtext       nvarchar(max),
    created         datetime not null,
    hash            varbinary(20),
    id              int      not null,
    modified        datetime not null,
    name            sysname  not null,
    paramorhinttext nvarchar(max),
    scopeid         int      not null,
    scopetype       tinyint  not null,
    status          int      not null
)
go

create unique clustered index clst
    on sys.syssqlguides (id)
go

create unique index nc1
    on sys.syssqlguides (name)
go

create unique index nc2
    on sys.syssqlguides (scopetype, scopeid, hash, id)
go

create table sys.systypedsubobjs
(
    class       tinyint  not null,
    collationid int      not null,
    idmajor     int      not null,
    intprop     int      not null,
    length      smallint not null,
    name        sysname,
    prec        tinyint  not null,
    scale       tinyint  not null,
    status      int      not null,
    subid       int      not null,
    utype       int      not null,
    xtype       tinyint  not null
)
go

create unique clustered index clst
    on sys.systypedsubobjs (class, idmajor, subid)
go

create unique index nc
    on sys.systypedsubobjs (name, idmajor, class)
go

create table sys.sysusermsgs
(
    id        int            not null,
    msglangid smallint       not null,
    severity  smallint       not null,
    status    smallint       not null,
    text      nvarchar(1024) not null
)
go

create unique clustered index clst
    on sys.sysusermsgs (id, msglangid)
go

create table sys.syswebmethods
(
    alias   nvarchar(64) not null,
    id      int          not null,
    nmspace nvarchar(384),
    objname nvarchar(776),
    status  int          not null
)
go

create unique clustered index clst
    on sys.syswebmethods (id, nmspace, alias)
go

create table sys.sysxlgns
(
    crdate  datetime not null,
    dbname  sysname,
    id      int      not null,
    lang    sysname,
    modate  datetime not null,
    name    sysname  not null,
    pwdhash varbinary(256),
    sid     varbinary(85),
    status  int      not null,
    type    char     not null
)
go

create unique clustered index cl
    on sys.sysxlgns (id)
go

create unique index nc1
    on sys.sysxlgns (name)
go

create unique index nc2
    on sys.sysxlgns (sid)
go

create table sys.sysxmitbody
(
    count   int    not null,
    msgbody varbinary(max),
    msgref  bigint not null
)
go

create unique clustered index clst
    on sys.sysxmitbody (msgref)
go

create table sys.sysxmitqueue
(
    dlgerr       int              not null,
    dlgid        uniqueidentifier not null,
    enqtime      datetime         not null,
    finitiator   bit              not null,
    frombrkrinst nvarchar(128),
    fromsvc      nvarchar(256),
    hdrpartlen   smallint         not null,
    hdrseclen    smallint         not null,
    msgbody      varbinary(max),
    msgbodylen   int              not null,
    msgenc       tinyint          not null,
    msgid        uniqueidentifier not null,
    msgref       bigint,
    msgseqnum    bigint           not null,
    msgtype      nvarchar(256),
    rsndtime     datetime,
    status       int              not null,
    svccontr     nvarchar(256),
    tobrkrinst   nvarchar(128),
    tosvc        nvarchar(256),
    unackmfn     int              not null
)
go

create unique clustered index clst
    on sys.sysxmitqueue (dlgid, finitiator, msgseqnum)
go

create table sys.sysxmlcomponent
(
    defval   nvarchar(4000),
    deriv    char    not null,
    enum     char    not null,
    id       int     not null,
    kind     char    not null,
    nameid   int     not null,
    nmscope  int     not null,
    qual     tinyint not null,
    status   int     not null,
    symspace char    not null,
    uriord   int     not null,
    xsdid    int     not null
)
go

create unique clustered index cl
    on sys.sysxmlcomponent (id)
go

create unique index nc1
    on sys.sysxmlcomponent (xsdid, uriord, qual, nameid, symspace, nmscope)
go

create table sys.sysxmlfacet
(
    compid int      not null,
    dflt   nvarchar(4000),
    kind   char(2)  not null,
    ord    int      not null,
    status smallint not null
)
go

create unique clustered index cl
    on sys.sysxmlfacet (compid, ord)
go

create table sys.sysxmlplacement
(
    defval    nvarchar(4000),
    maxoccur  int not null,
    minoccur  int not null,
    ordinal   int not null,
    placedid  int not null,
    placingid int not null,
    status    int not null
)
go

create unique clustered index cl
    on sys.sysxmlplacement (placingid, ordinal)
go

create unique index nc1
    on sys.sysxmlplacement (placedid, placingid, ordinal)
go

create table sys.sysxprops
(
    class tinyint not null,
    id    int     not null,
    name  sysname not null,
    subid int     not null,
    value sql_variant
)
go

create unique clustered index clust
    on sys.sysxprops (class, id, subid, name)
go

create table sys.sysxsrvs
(
    catalog        sysname,
    cid            int,
    connecttimeout int,
    id             int      not null,
    modate         datetime not null,
    name           sysname  not null,
    product        sysname  not null,
    provider       sysname  not null,
    querytimeout   int,
    status         int      not null
)
go

create unique clustered index cl
    on sys.sysxsrvs (id)
go

create unique index nc1
    on sys.sysxsrvs (name)
go

create table sys.trace_xe_action_map
(
    package_name    nvarchar(60) not null,
    trace_column_id smallint     not null,
    xe_action_name  nvarchar(60) not null
)
go

create table sys.trace_xe_event_map
(
    package_name   nvarchar(60) not null,
    trace_event_id smallint     not null,
    xe_event_name  nvarchar(60) not null
)
go

create view INFORMATION_SCHEMA.CHECK_CONSTRAINTS as -- missing source code
go

create view INFORMATION_SCHEMA.COLUMNS as -- missing source code
go

create view INFORMATION_SCHEMA.COLUMN_DOMAIN_USAGE as -- missing source code
go

create view INFORMATION_SCHEMA.COLUMN_PRIVILEGES as -- missing source code
go

create view INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE as -- missing source code
go

create view INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE as -- missing source code
go

create view INFORMATION_SCHEMA.DOMAINS as -- missing source code
go

create view INFORMATION_SCHEMA.DOMAIN_CONSTRAINTS as -- missing source code
go

create view INFORMATION_SCHEMA.KEY_COLUMN_USAGE as -- missing source code
go

create view INFORMATION_SCHEMA.PARAMETERS as -- missing source code
go

create view INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS as -- missing source code
go

create view INFORMATION_SCHEMA.ROUTINES as -- missing source code
go

create view INFORMATION_SCHEMA.ROUTINE_COLUMNS as -- missing source code
go

create view INFORMATION_SCHEMA.SCHEMATA as -- missing source code
go

create view INFORMATION_SCHEMA.SEQUENCES as -- missing source code
go

create view INFORMATION_SCHEMA.TABLES as -- missing source code
go

create view INFORMATION_SCHEMA.TABLE_CONSTRAINTS as -- missing source code
go

create view INFORMATION_SCHEMA.TABLE_PRIVILEGES as -- missing source code
go

create view INFORMATION_SCHEMA.VIEWS as -- missing source code
go

create view INFORMATION_SCHEMA.VIEW_COLUMN_USAGE as -- missing source code
go

create view INFORMATION_SCHEMA.VIEW_TABLE_USAGE as -- missing source code
go

create view sys.all_columns as -- missing source code
go

create view sys.all_objects as -- missing source code
go

create view sys.all_parameters as -- missing source code
go

create view sys.all_sql_modules as -- missing source code
go

create view sys.all_views as -- missing source code
go

create view sys.allocation_units as -- missing source code
go

create view sys.assemblies as -- missing source code
go

create view sys.assembly_files as -- missing source code
go

create view sys.assembly_modules as -- missing source code
go

create view sys.assembly_references as -- missing source code
go

create view sys.assembly_types as -- missing source code
go

create view sys.asymmetric_keys as -- missing source code
go

create view sys.availability_databases_cluster as -- missing source code
go

create view sys.availability_group_listener_ip_addresses as -- missing source code
go

create view sys.availability_group_listeners as -- missing source code
go

create view sys.availability_groups as -- missing source code
go

create view sys.availability_groups_cluster as -- missing source code
go

create view sys.availability_read_only_routing_lists as -- missing source code
go

create view sys.availability_replicas as -- missing source code
go

create view sys.backup_devices as -- missing source code
go

create view sys.certificates as -- missing source code
go

create view sys.change_tracking_databases as -- missing source code
go

create view sys.change_tracking_tables as -- missing source code
go

create view sys.check_constraints as -- missing source code
go

create view sys.column_encryption_key_values as -- missing source code
go

create view sys.column_encryption_keys as -- missing source code
go

create view sys.column_master_keys as -- missing source code
go

create view sys.column_store_dictionaries as -- missing source code
go

create view sys.column_store_row_groups as -- missing source code
go

create view sys.column_store_segments as -- missing source code
go

create view sys.column_type_usages as -- missing source code
go

create view sys.column_xml_schema_collection_usages as -- missing source code
go

create view sys.columns as -- missing source code
go

create view sys.computed_columns as -- missing source code
go

create view sys.configurations as -- missing source code
go

create view sys.conversation_endpoints as -- missing source code
go

create view sys.conversation_groups as -- missing source code
go

create view sys.conversation_priorities as -- missing source code
go

create view sys.credentials as -- missing source code
go

create view sys.crypt_properties as -- missing source code
go

create view sys.cryptographic_providers as -- missing source code
go

create view sys.data_spaces as -- missing source code
go

create view sys.database_audit_specification_details as -- missing source code
go

create view sys.database_audit_specifications as -- missing source code
go

create view sys.database_automatic_tuning_mode as -- missing source code
go

create view sys.database_automatic_tuning_options as -- missing source code
go

create view sys.database_credentials as -- missing source code
go

create view sys.database_files as -- missing source code
go

create view sys.database_filestream_options as -- missing source code
go

create view sys.database_mirroring as -- missing source code
go

create view sys.database_mirroring_endpoints as -- missing source code
go

create view sys.database_mirroring_witnesses as -- missing source code
go

create view sys.database_permissions as -- missing source code
go

create view sys.database_principals as -- missing source code
go

create view sys.database_query_store_options as -- missing source code
go

create view sys.database_recovery_status as -- missing source code
go

create view sys.database_role_members as -- missing source code
go

create view sys.database_scoped_configurations as -- missing source code
go

create view sys.database_scoped_credentials as -- missing source code
go

create view sys.databases as -- missing source code
go

create view sys.default_constraints as -- missing source code
go

create view sys.destination_data_spaces as -- missing source code
go

create view sys.dm_audit_actions as -- missing source code
go

create view sys.dm_audit_class_type_map as -- missing source code
go

create view sys.dm_broker_activated_tasks as -- missing source code
go

create view sys.dm_broker_connections as -- missing source code
go

create view sys.dm_broker_forwarded_messages as -- missing source code
go

create view sys.dm_broker_queue_monitors as -- missing source code
go

create view sys.dm_cdc_errors as -- missing source code
go

create view sys.dm_cdc_log_scan_sessions as -- missing source code
go

create view sys.dm_clr_appdomains as -- missing source code
go

create view sys.dm_clr_loaded_assemblies as -- missing source code
go

create view sys.dm_clr_properties as -- missing source code
go

create view sys.dm_clr_tasks as -- missing source code
go

create view sys.dm_column_store_object_pool as -- missing source code
go

create view sys.dm_cryptographic_provider_properties as -- missing source code
go

create view sys.dm_database_encryption_keys as -- missing source code
go

create view sys.dm_db_column_store_row_group_operational_stats as -- missing source code
go

create view sys.dm_db_column_store_row_group_physical_stats as -- missing source code
go

create view sys.dm_db_file_space_usage as -- missing source code
go

create view sys.dm_db_fts_index_physical_stats as -- missing source code
go

create view sys.dm_db_index_usage_stats as -- missing source code
go

create view sys.dm_db_log_space_usage as -- missing source code
go

create view sys.dm_db_mirroring_auto_page_repair as -- missing source code
go

create view sys.dm_db_mirroring_connections as -- missing source code
go

create view sys.dm_db_mirroring_past_actions as -- missing source code
go

create view sys.dm_db_missing_index_details as -- missing source code
go

create view sys.dm_db_missing_index_group_stats as -- missing source code
go

create view sys.dm_db_missing_index_groups as -- missing source code
go

create view sys.dm_db_partition_stats as -- missing source code
go

create view sys.dm_db_persisted_sku_features as -- missing source code
go

create view sys.dm_db_rda_migration_status as -- missing source code
go

create view sys.dm_db_rda_schema_update_status as -- missing source code
go

create view sys.dm_db_script_level as -- missing source code
go

create view sys.dm_db_session_space_usage as -- missing source code
go

create view sys.dm_db_task_space_usage as -- missing source code
go

create view sys.dm_db_tuning_recommendations as -- missing source code
go

create view sys.dm_db_uncontained_entities as -- missing source code
go

create view sys.dm_db_xtp_checkpoint_files as -- missing source code
go

create view sys.dm_db_xtp_checkpoint_internals as -- missing source code
go

create view sys.dm_db_xtp_checkpoint_stats as -- missing source code
go

create view sys.dm_db_xtp_gc_cycle_stats as -- missing source code
go

create view sys.dm_db_xtp_hash_index_stats as -- missing source code
go

create view sys.dm_db_xtp_index_stats as -- missing source code
go

create view sys.dm_db_xtp_memory_consumers as -- missing source code
go

create view sys.dm_db_xtp_nonclustered_index_stats as -- missing source code
go

create view sys.dm_db_xtp_object_stats as -- missing source code
go

create view sys.dm_db_xtp_table_memory_stats as -- missing source code
go

create view sys.dm_db_xtp_transactions as -- missing source code
go

create view sys.dm_exec_background_job_queue as -- missing source code
go

create view sys.dm_exec_background_job_queue_stats as -- missing source code
go

create view sys.dm_exec_cached_plans as -- missing source code
go

create view sys.dm_exec_compute_node_errors as -- missing source code
go

create view sys.dm_exec_compute_node_status as -- missing source code
go

create view sys.dm_exec_compute_nodes as -- missing source code
go

create view sys.dm_exec_connections as -- missing source code
go

create view sys.dm_exec_distributed_request_steps as -- missing source code
go

create view sys.dm_exec_distributed_requests as -- missing source code
go

create view sys.dm_exec_distributed_sql_requests as -- missing source code
go

create view sys.dm_exec_dms_services as -- missing source code
go

create view sys.dm_exec_dms_workers as -- missing source code
go

create view sys.dm_exec_external_operations as -- missing source code
go

create view sys.dm_exec_external_work as -- missing source code
go

create view sys.dm_exec_function_stats as -- missing source code
go

create view sys.dm_exec_procedure_stats as -- missing source code
go

create view sys.dm_exec_query_memory_grants as -- missing source code
go

create view sys.dm_exec_query_optimizer_info as -- missing source code
go

create view sys.dm_exec_query_optimizer_memory_gateways as -- missing source code
go

create view sys.dm_exec_query_parallel_workers as -- missing source code
go

create view sys.dm_exec_query_profiles as -- missing source code
go

create view sys.dm_exec_query_resource_semaphores as -- missing source code
go

create view sys.dm_exec_query_stats as -- missing source code
go

create view sys.dm_exec_query_transformation_stats as -- missing source code
go

create view sys.dm_exec_requests as -- missing source code
go

create view sys.dm_exec_session_wait_stats as -- missing source code
go

create view sys.dm_exec_sessions as -- missing source code
go

create view sys.dm_exec_trigger_stats as -- missing source code
go

create view sys.dm_exec_valid_use_hints as -- missing source code
go

create view sys.dm_external_script_execution_stats as -- missing source code
go

create view sys.dm_external_script_requests as -- missing source code
go

create view sys.dm_filestream_file_io_handles as -- missing source code
go

create view sys.dm_filestream_file_io_requests as -- missing source code
go

create view sys.dm_filestream_non_transacted_handles as -- missing source code
go

create view sys.dm_fts_active_catalogs as -- missing source code
go

create view sys.dm_fts_fdhosts as -- missing source code
go

create view sys.dm_fts_index_population as -- missing source code
go

create view sys.dm_fts_memory_buffers as -- missing source code
go

create view sys.dm_fts_memory_pools as -- missing source code
go

create view sys.dm_fts_outstanding_batches as -- missing source code
go

create view sys.dm_fts_population_ranges as -- missing source code
go

create view sys.dm_fts_semantic_similarity_population as -- missing source code
go

create view sys.dm_hadr_auto_page_repair as -- missing source code
go

create view sys.dm_hadr_automatic_seeding as -- missing source code
go

create view sys.dm_hadr_availability_group_states as -- missing source code
go

create view sys.dm_hadr_availability_replica_cluster_nodes as -- missing source code
go

create view sys.dm_hadr_availability_replica_cluster_states as -- missing source code
go

create view sys.dm_hadr_availability_replica_states as -- missing source code
go

create view sys.dm_hadr_cluster as -- missing source code
go

create view sys.dm_hadr_cluster_members as -- missing source code
go

create view sys.dm_hadr_cluster_networks as -- missing source code
go

create view sys.dm_hadr_database_replica_cluster_states as -- missing source code
go

create view sys.dm_hadr_database_replica_states as -- missing source code
go

create view sys.dm_hadr_instance_node_map as -- missing source code
go

create view sys.dm_hadr_name_id_map as -- missing source code
go

create view sys.dm_hadr_physical_seeding_stats as -- missing source code
go

create view sys.dm_io_backup_tapes as -- missing source code
go

create view sys.dm_io_cluster_shared_drives as -- missing source code
go

create view sys.dm_io_cluster_valid_path_names as -- missing source code
go

create view sys.dm_io_pending_io_requests as -- missing source code
go

create view sys.dm_logpool_hashentries as -- missing source code
go

create view sys.dm_logpool_stats as -- missing source code
go

create view sys.dm_os_buffer_descriptors as -- missing source code
go

create view sys.dm_os_buffer_pool_extension_configuration as -- missing source code
go

create view sys.dm_os_child_instances as -- missing source code
go

create view sys.dm_os_cluster_nodes as -- missing source code
go

create view sys.dm_os_cluster_properties as -- missing source code
go

create view sys.dm_os_dispatcher_pools as -- missing source code
go

create view sys.dm_os_dispatchers as -- missing source code
go

create view sys.dm_os_enumerate_fixed_drives as -- missing source code
go

create view sys.dm_os_host_info as -- missing source code
go

create view sys.dm_os_hosts as -- missing source code
go

create view sys.dm_os_latch_stats as -- missing source code
go

create view sys.dm_os_loaded_modules as -- missing source code
go

create view sys.dm_os_memory_allocations as -- missing source code
go

create view sys.dm_os_memory_broker_clerks as -- missing source code
go

create view sys.dm_os_memory_brokers as -- missing source code
go

create view sys.dm_os_memory_cache_clock_hands as -- missing source code
go

create view sys.dm_os_memory_cache_counters as -- missing source code
go

create view sys.dm_os_memory_cache_entries as -- missing source code
go

create view sys.dm_os_memory_cache_hash_tables as -- missing source code
go

create view sys.dm_os_memory_clerks as -- missing source code
go

create view sys.dm_os_memory_node_access_stats as -- missing source code
go

create view sys.dm_os_memory_nodes as -- missing source code
go

create view sys.dm_os_memory_objects as -- missing source code
go

create view sys.dm_os_memory_pools as -- missing source code
go

create view sys.dm_os_nodes as -- missing source code
go

create view sys.dm_os_performance_counters as -- missing source code
go

create view sys.dm_os_process_memory as -- missing source code
go

create view sys.dm_os_ring_buffers as -- missing source code
go

create view sys.dm_os_schedulers as -- missing source code
go

create view sys.dm_os_server_diagnostics_log_configurations as -- missing source code
go

create view sys.dm_os_spinlock_stats as -- missing source code
go

create view sys.dm_os_stacks as -- missing source code
go

create view sys.dm_os_sublatches as -- missing source code
go

create view sys.dm_os_sys_info as -- missing source code
go

create view sys.dm_os_sys_memory as -- missing source code
go

create view sys.dm_os_tasks as -- missing source code
go

create view sys.dm_os_threads as -- missing source code
go

create view sys.dm_os_virtual_address_dump as -- missing source code
go

create view sys.dm_os_wait_stats as -- missing source code
go

create view sys.dm_os_waiting_tasks as -- missing source code
go

create view sys.dm_os_windows_info as -- missing source code
go

create view sys.dm_os_worker_local_storage as -- missing source code
go

create view sys.dm_os_workers as -- missing source code
go

create view sys.dm_qn_subscriptions as -- missing source code
go

create view sys.dm_repl_articles as -- missing source code
go

create view sys.dm_repl_schemas as -- missing source code
go

create view sys.dm_repl_tranhash as -- missing source code
go

create view sys.dm_repl_traninfo as -- missing source code
go

create view sys.dm_resource_governor_configuration as -- missing source code
go

create view sys.dm_resource_governor_external_resource_pool_affinity as -- missing source code
go

create view sys.dm_resource_governor_external_resource_pools as -- missing source code
go

create view sys.dm_resource_governor_resource_pool_affinity as -- missing source code
go

create view sys.dm_resource_governor_resource_pool_volumes as -- missing source code
go

create view sys.dm_resource_governor_resource_pools as -- missing source code
go

create view sys.dm_resource_governor_workload_groups as -- missing source code
go

create view sys.dm_server_audit_status as -- missing source code
go

create view sys.dm_server_memory_dumps as -- missing source code
go

create view sys.dm_server_registry as -- missing source code
go

create view sys.dm_server_services as -- missing source code
go

create view sys.dm_tcp_listener_states as -- missing source code
go

create view sys.dm_tran_active_snapshot_database_transactions as -- missing source code
go

create view sys.dm_tran_active_transactions as -- missing source code
go

create view sys.dm_tran_commit_table as -- missing source code
go

create view sys.dm_tran_current_snapshot as -- missing source code
go

create view sys.dm_tran_current_transaction as -- missing source code
go

create view sys.dm_tran_database_transactions as -- missing source code
go

create view sys.dm_tran_global_recovery_transactions as -- missing source code
go

create view sys.dm_tran_global_transactions as -- missing source code
go

create view sys.dm_tran_global_transactions_enlistments as -- missing source code
go

create view sys.dm_tran_global_transactions_log as -- missing source code
go

create view sys.dm_tran_locks as -- missing source code
go

create view sys.dm_tran_session_transactions as -- missing source code
go

create view sys.dm_tran_top_version_generators as -- missing source code
go

create view sys.dm_tran_transactions_snapshot as -- missing source code
go

create view sys.dm_tran_version_store as -- missing source code
go

create view sys.dm_tran_version_store_space_usage as -- missing source code
go

create view sys.dm_xe_map_values as -- missing source code
go

create view sys.dm_xe_object_columns as -- missing source code
go

create view sys.dm_xe_objects as -- missing source code
go

create view sys.dm_xe_packages as -- missing source code
go

create view sys.dm_xe_session_event_actions as -- missing source code
go

create view sys.dm_xe_session_events as -- missing source code
go

create view sys.dm_xe_session_object_columns as -- missing source code
go

create view sys.dm_xe_session_targets as -- missing source code
go

create view sys.dm_xe_sessions as -- missing source code
go

create view sys.dm_xtp_gc_queue_stats as -- missing source code
go

create view sys.dm_xtp_gc_stats as -- missing source code
go

create view sys.dm_xtp_system_memory_consumers as -- missing source code
go

create view sys.dm_xtp_threads as -- missing source code
go

create view sys.dm_xtp_transaction_recent_rows as -- missing source code
go

create view sys.dm_xtp_transaction_stats as -- missing source code
go

create view sys.endpoint_webmethods as -- missing source code
go

create view sys.endpoints as -- missing source code
go

create view sys.event_notification_event_types as -- missing source code
go

create view sys.event_notifications as -- missing source code
go

create view sys.events as -- missing source code
go

create view sys.extended_procedures as -- missing source code
go

create view sys.extended_properties as -- missing source code
go

create view sys.external_data_sources as -- missing source code
go

create view sys.external_file_formats as -- missing source code
go

create view sys.external_libraries as -- missing source code
go

create view sys.external_library_files as -- missing source code
go

create view sys.external_tables as -- missing source code
go

create view sys.filegroups as -- missing source code
go

create view sys.filetable_system_defined_objects as -- missing source code
go

create view sys.filetables as -- missing source code
go

create view sys.foreign_key_columns as -- missing source code
go

create view sys.foreign_keys as -- missing source code
go

create view sys.fulltext_catalogs as -- missing source code
go

create view sys.fulltext_document_types as -- missing source code
go

create view sys.fulltext_index_catalog_usages as -- missing source code
go

create view sys.fulltext_index_columns as -- missing source code
go

create view sys.fulltext_index_fragments as -- missing source code
go

create view sys.fulltext_indexes as -- missing source code
go

create view sys.fulltext_languages as -- missing source code
go

create view sys.fulltext_semantic_language_statistics_database as -- missing source code
go

create view sys.fulltext_semantic_languages as -- missing source code
go

create view sys.fulltext_stoplists as -- missing source code
go

create view sys.fulltext_stopwords as -- missing source code
go

create view sys.fulltext_system_stopwords as -- missing source code
go

create view sys.function_order_columns as -- missing source code
go

create view sys.hash_indexes as -- missing source code
go

create view sys.http_endpoints as -- missing source code
go

create view sys.identity_columns as -- missing source code
go

create view sys.index_columns as -- missing source code
go

create view sys.index_resumable_operations as -- missing source code
go

create view sys.indexes as -- missing source code
go

create view sys.internal_partitions as -- missing source code
go

create view sys.internal_tables as -- missing source code
go

create view sys.key_constraints as -- missing source code
go

create view sys.key_encryptions as -- missing source code
go

create view sys.linked_logins as -- missing source code
go

create view sys.login_token as -- missing source code
go

create view sys.masked_columns as -- missing source code
go

create view sys.master_files as -- missing source code
go

create view sys.master_key_passwords as -- missing source code
go

create view sys.memory_optimized_tables_internal_attributes as -- missing source code
go

create view sys.message_type_xml_schema_collection_usages as -- missing source code
go

create view sys.messages as -- missing source code
go

create view sys.module_assembly_usages as -- missing source code
go

create view sys.numbered_procedure_parameters as -- missing source code
go

create view sys.numbered_procedures as -- missing source code
go

create view sys.objects as -- missing source code
go

create view sys.openkeys as -- missing source code
go

create view sys.parameter_type_usages as -- missing source code
go

create view sys.parameter_xml_schema_collection_usages as -- missing source code
go

create view sys.parameters as -- missing source code
go

create view sys.partition_functions as -- missing source code
go

create view sys.partition_parameters as -- missing source code
go

create view sys.partition_range_values as -- missing source code
go

create view sys.partition_schemes as -- missing source code
go

create view sys.partitions as -- missing source code
go

create view sys.periods as -- missing source code
go

create view sys.plan_guides as -- missing source code
go

create view sys.procedures as -- missing source code
go

create view sys.query_context_settings as -- missing source code
go

create view sys.query_store_plan as -- missing source code
go

create view sys.query_store_query as -- missing source code
go

create view sys.query_store_query_text as -- missing source code
go

create view sys.query_store_runtime_stats as -- missing source code
go

create view sys.query_store_runtime_stats_interval as -- missing source code
go

create view sys.query_store_wait_stats as -- missing source code
go

create view sys.registered_search_properties as -- missing source code
go

create view sys.registered_search_property_lists as -- missing source code
go

create view sys.remote_data_archive_databases as -- missing source code
go

create view sys.remote_data_archive_tables as -- missing source code
go

create view sys.remote_logins as -- missing source code
go

create view sys.remote_service_bindings as -- missing source code
go

create view sys.resource_governor_configuration as -- missing source code
go

create view sys.resource_governor_external_resource_pool_affinity as -- missing source code
go

create view sys.resource_governor_external_resource_pools as -- missing source code
go

create view sys.resource_governor_resource_pool_affinity as -- missing source code
go

create view sys.resource_governor_resource_pools as -- missing source code
go

create view sys.resource_governor_workload_groups as -- missing source code
go

create view sys.routes as -- missing source code
go

create view sys.schemas as -- missing source code
go

create view sys.securable_classes as -- missing source code
go

create view sys.security_policies as -- missing source code
go

create view sys.security_predicates as -- missing source code
go

create view sys.selective_xml_index_namespaces as -- missing source code
go

create view sys.selective_xml_index_paths as -- missing source code
go

create view sys.sequences as -- missing source code
go

create view sys.server_assembly_modules as -- missing source code
go

create view sys.server_audit_specification_details as -- missing source code
go

create view sys.server_audit_specifications as -- missing source code
go

create view sys.server_audits as -- missing source code
go

create view sys.server_event_notifications as -- missing source code
go

create view sys.server_event_session_actions as -- missing source code
go

create view sys.server_event_session_events as -- missing source code
go

create view sys.server_event_session_fields as -- missing source code
go

create view sys.server_event_session_targets as -- missing source code
go

create view sys.server_event_sessions as -- missing source code
go

create view sys.server_events as -- missing source code
go

create view sys.server_file_audits as -- missing source code
go

create view sys.server_permissions as -- missing source code
go

create view sys.server_principal_credentials as -- missing source code
go

create view sys.server_principals as -- missing source code
go

create view sys.server_role_members as -- missing source code
go

create view sys.server_sql_modules as -- missing source code
go

create view sys.server_trigger_events as -- missing source code
go

create view sys.server_triggers as -- missing source code
go

create view sys.servers as -- missing source code
go

create view sys.service_broker_endpoints as -- missing source code
go

create view sys.service_contract_message_usages as -- missing source code
go

create view sys.service_contract_usages as -- missing source code
go

create view sys.service_contracts as -- missing source code
go

create view sys.service_message_types as -- missing source code
go

create view sys.service_queue_usages as -- missing source code
go

create view sys.service_queues as -- missing source code
go

create view sys.services as -- missing source code
go

create view sys.soap_endpoints as -- missing source code
go

create view sys.spatial_index_tessellations as -- missing source code
go

create view sys.spatial_indexes as -- missing source code
go

create view sys.spatial_reference_systems as -- missing source code
go

create view sys.sql_dependencies as -- missing source code
go

create view sys.sql_expression_dependencies as -- missing source code
go

create view sys.sql_logins as -- missing source code
go

create view sys.sql_modules as -- missing source code
go

create view sys.stats as -- missing source code
go

create view sys.stats_columns as -- missing source code
go

create view sys.symmetric_keys as -- missing source code
go

create view sys.synonyms as -- missing source code
go

create view sys.sysaltfiles as -- missing source code
go

create view sys.syscacheobjects as -- missing source code
go

create view sys.syscharsets as -- missing source code
go

create view sys.syscolumns as -- missing source code
go

create view sys.syscomments as -- missing source code
go

create view sys.sysconfigures as -- missing source code
go

create view sys.sysconstraints as -- missing source code
go

create view sys.syscscontainers as -- missing source code
go

create view sys.syscurconfigs as -- missing source code
go

create view sys.syscursorcolumns as -- missing source code
go

create view sys.syscursorrefs as -- missing source code
go

create view sys.syscursors as -- missing source code
go

create view sys.syscursortables as -- missing source code
go

create view sys.sysdatabases as -- missing source code
go

create view sys.sysdepends as -- missing source code
go

create view sys.sysdevices as -- missing source code
go

create view sys.sysfilegroups as -- missing source code
go

create view sys.sysfiles as -- missing source code
go

create view sys.sysforeignkeys as -- missing source code
go

create view sys.sysfulltextcatalogs as -- missing source code
go

create view sys.sysindexes as -- missing source code
go

create view sys.sysindexkeys as -- missing source code
go

create view sys.syslanguages as -- missing source code
go

create view sys.syslockinfo as -- missing source code
go

create view sys.syslogins as -- missing source code
go

create view sys.sysmembers as -- missing source code
go

create view sys.sysmessages as -- missing source code
go

create view sys.sysobjects as -- missing source code
go

create view sys.sysoledbusers as -- missing source code
go

create view sys.sysopentapes as -- missing source code
go

create view sys.sysperfinfo as -- missing source code
go

create view sys.syspermissions as -- missing source code
go

create view sys.sysprocesses as -- missing source code
go

create view sys.sysprotects as -- missing source code
go

create view sys.sysreferences as -- missing source code
go

create view sys.sysremotelogins as -- missing source code
go

create view sys.sysservers as -- missing source code
go

create view sys.system_columns as -- missing source code
go

create view sys.system_components_surface_area_configuration as -- missing source code
go

create view sys.system_internals_allocation_units as -- missing source code
go

create view sys.system_internals_partition_columns as -- missing source code
go

create view sys.system_internals_partitions as -- missing source code
go

create view sys.system_objects as -- missing source code
go

create view sys.system_parameters as -- missing source code
go

create view sys.system_sql_modules as -- missing source code
go

create view sys.system_views as -- missing source code
go

create view sys.systypes as -- missing source code
go

create view sys.sysusers as -- missing source code
go

create view sys.table_types as -- missing source code
go

create view sys.tables as -- missing source code
go

create view sys.tcp_endpoints as -- missing source code
go

create view sys.time_zone_info as -- missing source code
go

create view sys.trace_categories as -- missing source code
go

create view sys.trace_columns as -- missing source code
go

create view sys.trace_event_bindings as -- missing source code
go

create view sys.trace_events as -- missing source code
go

create view sys.trace_subclass_values as -- missing source code
go

create view sys.traces as -- missing source code
go

create view sys.transmission_queue as -- missing source code
go

create view sys.trigger_event_types as -- missing source code
go

create view sys.trigger_events as -- missing source code
go

create view sys.triggers as -- missing source code
go

create view sys.trusted_assemblies as -- missing source code
go

create view sys.type_assembly_usages as -- missing source code
go

create view sys.types as -- missing source code
go

create view sys.user_token as -- missing source code
go

create view sys.via_endpoints as -- missing source code
go

create view sys.views as -- missing source code
go

create view sys.xml_indexes as -- missing source code
go

create view sys.xml_schema_attributes as -- missing source code
go

create view sys.xml_schema_collections as -- missing source code
go

create view sys.xml_schema_component_placements as -- missing source code
go

create view sys.xml_schema_components as -- missing source code
go

create view sys.xml_schema_elements as -- missing source code
go

create view sys.xml_schema_facets as -- missing source code
go

create view sys.xml_schema_model_groups as -- missing source code
go

create view sys.xml_schema_namespaces as -- missing source code
go

create view sys.xml_schema_types as -- missing source code
go

create view sys.xml_schema_wildcard_namespaces as -- missing source code
go

create view sys.xml_schema_wildcards as -- missing source code
go

create function sys.dm_cryptographic_provider_algorithms([@ProviderId] int) as -- missing source code
go

create function sys.dm_cryptographic_provider_keys([@ProviderId] int) as -- missing source code
go

create function sys.dm_cryptographic_provider_sessions([@all] int) as -- missing source code
go

create function sys.dm_db_database_page_allocations([@DatabaseId] smallint, [@IndexId] int, [@Mode] nvarchar(64),
                                                    [@PartitionId] bigint, [@TableId] int) as -- missing source code
go

create function sys.dm_db_incremental_stats_properties([@object_id] int, [@stats_id] int) as -- missing source code
go

create function sys.dm_db_index_operational_stats([@DatabaseId] smallint, [@IndexId] int, [@PartitionNumber] int,
                                                  [@TableId] int) as -- missing source code
go

create function sys.dm_db_index_physical_stats([@DatabaseId] smallint, [@IndexId] int, [@Mode] nvarchar(20),
                                               [@ObjectId] int, [@PartitionNumber] int) as -- missing source code
go

create function sys.dm_db_log_info([@DatabaseId] int) as -- missing source code
go

create function sys.dm_db_log_stats([@DatabaseId] int) as -- missing source code
go

create function sys.dm_db_missing_index_columns([@handle] int) as -- missing source code
go

create function sys.dm_db_objects_disabled_on_compatibility_level_change([@compatibility_level] int) as -- missing source code
go

create function sys.dm_db_stats_histogram([@object_id] int, [@stats_id] int) as -- missing source code
go

create function sys.dm_db_stats_properties([@object_id] int, [@stats_id] int) as -- missing source code
go

create function sys.dm_db_stats_properties_internal([@object_id] int, [@stats_id] int) as -- missing source code
go

create function sys.dm_exec_cached_plan_dependent_objects([@planhandle] varbinary(64)) as -- missing source code
go

create function sys.dm_exec_cursors([@spid] int) as -- missing source code
go

create function sys.dm_exec_describe_first_result_set([@browse_information_mode] tinyint, [@params] nvarchar(max),
                                                      [@tsql] nvarchar(max)) as -- missing source code
go

create function sys.dm_exec_describe_first_result_set_for_object([@browse_information_mode] tinyint, [@object_id] int) as -- missing source code
go

create function sys.dm_exec_input_buffer([@request_id] int, [@session_id] smallint) as -- missing source code
go

create function sys.dm_exec_plan_attributes([@handle] varbinary(64)) as -- missing source code
go

create function sys.dm_exec_query_plan([@handle] varbinary(64)) as -- missing source code
go

create function sys.dm_exec_query_statistics_xml([@session_id] smallint) as -- missing source code
go

create function sys.dm_exec_sql_text([@handle] varbinary(64)) as -- missing source code
go

create function sys.dm_exec_text_query_plan([@handle] varbinary(64), [@stmt_end_offset] int,
                                            [@stmt_start_offset] int) as -- missing source code
go

create function sys.dm_exec_xml_handles([@spid] int) as -- missing source code
go

create function sys.dm_fts_index_keywords([@dbid] int, [@objid] int) as -- missing source code
go

create function sys.dm_fts_index_keywords_by_document([@dbid] int, [@objid] int) as -- missing source code
go

create function sys.dm_fts_index_keywords_by_property([@dbid] int, [@objid] int) as -- missing source code
go

create function sys.dm_fts_index_keywords_position_by_document([@dbid] int, [@objid] int) as -- missing source code
go

create function sys.dm_fts_parser([@accentsensitive] bit, [@lcid] int, [@querystring] nvarchar(4000),
                                  [@stoplistid] int) as -- missing source code
go

create function sys.dm_io_virtual_file_stats([@DatabaseId] int, [@FileId] int) as -- missing source code
go

create function sys.dm_logconsumer_cachebufferrefs([@ConsumerId] bigint, [@DatabaseId] int) as -- missing source code
go

create function sys.dm_logconsumer_privatecachebuffers([@ConsumerId] bigint, [@DatabaseId] int) as -- missing source code
go

create function sys.dm_logpool_consumers([@DatabaseId] int) as -- missing source code
go

create function sys.dm_logpool_sharedcachebuffers([@DatabaseId] int) as -- missing source code
go

create function sys.dm_logpoolmgr_freepools([@DatabaseId] int) as -- missing source code
go

create function sys.dm_logpoolmgr_respoolsize([@DatabaseId] int) as -- missing source code
go

create function sys.dm_logpoolmgr_stats([@DatabaseId] int) as -- missing source code
go

create function sys.dm_os_enumerate_filesystem([@initial_directory] nvarchar(255),
                                               [@search_pattern] nvarchar(255)) as -- missing source code
go

create function sys.dm_os_file_exists([@file_or_directory] nvarchar(255)) as -- missing source code
go

create function sys.dm_os_volume_stats([@DatabaseId] int, [@FileId] int) as -- missing source code
go

create function sys.dm_sql_referenced_entities([@name] nvarchar(517), [@referencing_class] nvarchar(60)) as -- missing source code
go

create function sys.dm_sql_referencing_entities([@name] nvarchar(517), [@referenced_class] nvarchar(60)) as -- missing source code
go

create function sys.fn_EnumCurrentPrincipals() as -- missing source code
go

create function sys.fn_GetCurrentPrincipal([@db_name] sysname) returns sysname as -- missing source code
go

create function sys.fn_GetRowsetIdFromRowDump([@rowdump] varbinary(max)) returns bigint as -- missing source code
go

create function sys.fn_IsBitSetInBitmask([@bitmask] varbinary(500), [@colid] int) returns int as -- missing source code
go

create function sys.fn_MSdayasnumber([@day] datetime) returns int as -- missing source code
go

create function sys.fn_MSgeneration_downloadonly([@generation] bigint, [@tablenick] int) returns bigint as -- missing source code
go

create function sys.fn_MSget_dynamic_filter_login([@partition_id] int, [@publication_number] int) returns sysname as -- missing source code
go

create function sys.fn_MSorbitmaps([@bm1] varbinary(128), [@bm2] varbinary(128)) returns varbinary(128) as -- missing source code
go

create function sys.fn_MSrepl_getsrvidfromdistdb([@srvid] smallint) returns int as -- missing source code
go

create function sys.fn_MSrepl_map_resolver_clsid([@article_resolver] nvarchar(255), [@compatibility_level] int,
                                                 [@resolver_clsid] nvarchar(60)) returns nvarchar(60) as -- missing source code
go

create function sys.fn_MStestbit([@bitmap] varbinary(128), [@colidx] smallint) returns bit as -- missing source code
go

create function sys.fn_MSvector_downloadonly([@tablenick] int, [@vector] varbinary(2953)) returns varbinary(311) as -- missing source code
go

create function sys.fn_MSxe_read_event_stream([@source] nvarchar(260), [@source_opt] int) as -- missing source code
go

create function sys.fn_MapSchemaType([@schemasubtype] int, [@schematype] int) returns sysname as -- missing source code
go

create function sys.fn_PhysLocCracker([@physical_locator] binary(8)) as -- missing source code
go

create function sys.fn_PhysLocFormatter([@physical_locator] binary(8)) returns varchar(128) as -- missing source code
go

create function sys.fn_RowDumpCracker([@rowdump] varbinary(max)) as -- missing source code
go

create function sys.fn_builtin_permissions([@level] nvarchar(60)) as -- missing source code
go

create function sys.fn_cColvEntries_80([@artnick] int, [@pubid] uniqueidentifier) returns int as -- missing source code
go

create function sys.fn_cdc_check_parameters([@capture_instance] sysname, [@from_lsn] binary(10), [@net_changes] bit,
                                            [@row_filter_option] nvarchar(30),
                                            [@to_lsn] binary(10)) returns bit as -- missing source code
go

create function sys.fn_cdc_get_column_ordinal([@capture_instance] sysname, [@column_name] sysname) returns int as -- missing source code
go

create function sys.fn_cdc_get_max_lsn() returns binary(10) as -- missing source code
go

create function sys.fn_cdc_get_min_lsn([@capture_instance] sysname) returns binary(10) as -- missing source code
go

create function sys.fn_cdc_has_column_changed([@capture_instance] sysname, [@column_name] sysname,
                                              [@update_mask] varbinary(128)) returns bit as -- missing source code
go

create function sys.fn_cdc_hexstrtobin([@hexstr] nvarchar(40)) returns binary(10) as -- missing source code
go

create function sys.fn_cdc_map_lsn_to_time([@lsn] binary(10)) returns datetime as -- missing source code
go

create function sys.fn_cdc_map_time_to_lsn([@relational_operator] nvarchar(30), [@tracking_time] datetime) returns binary(10) as -- missing source code
go

create function sys.fn_check_object_signatures([@class] sysname, [@thumbprint] varbinary(20)) as -- missing source code
go

create function sys.fn_column_store_row_groups([@obj_id] bigint) as -- missing source code
go

create function sys.fn_db_backup_file_snapshots([@database_name] sysname) as -- missing source code
go

create function sys.fn_dblog([@end] nvarchar(25), [@start] nvarchar(25)) as -- missing source code
go

create function sys.fn_dblog_xtp([@end] nvarchar(25), [@start] nvarchar(25)) as -- missing source code
go

create function sys.fn_dump_dblog([@devtype] nvarchar(260), [@end] nvarchar(25), [@fname1] nvarchar(260),
                                  [@fname10] nvarchar(260), [@fname11] nvarchar(260), [@fname12] nvarchar(260),
                                  [@fname13] nvarchar(260), [@fname14] nvarchar(260), [@fname15] nvarchar(260),
                                  [@fname16] nvarchar(260), [@fname17] nvarchar(260), [@fname18] nvarchar(260),
                                  [@fname19] nvarchar(260), [@fname2] nvarchar(260), [@fname20] nvarchar(260),
                                  [@fname21] nvarchar(260), [@fname22] nvarchar(260), [@fname23] nvarchar(260),
                                  [@fname24] nvarchar(260), [@fname25] nvarchar(260), [@fname26] nvarchar(260),
                                  [@fname27] nvarchar(260), [@fname28] nvarchar(260), [@fname29] nvarchar(260),
                                  [@fname3] nvarchar(260), [@fname30] nvarchar(260), [@fname31] nvarchar(260),
                                  [@fname32] nvarchar(260), [@fname33] nvarchar(260), [@fname34] nvarchar(260),
                                  [@fname35] nvarchar(260), [@fname36] nvarchar(260), [@fname37] nvarchar(260),
                                  [@fname38] nvarchar(260), [@fname39] nvarchar(260), [@fname4] nvarchar(260),
                                  [@fname40] nvarchar(260), [@fname41] nvarchar(260), [@fname42] nvarchar(260),
                                  [@fname43] nvarchar(260), [@fname44] nvarchar(260), [@fname45] nvarchar(260),
                                  [@fname46] nvarchar(260), [@fname47] nvarchar(260), [@fname48] nvarchar(260),
                                  [@fname49] nvarchar(260), [@fname5] nvarchar(260), [@fname50] nvarchar(260),
                                  [@fname51] nvarchar(260), [@fname52] nvarchar(260), [@fname53] nvarchar(260),
                                  [@fname54] nvarchar(260), [@fname55] nvarchar(260), [@fname56] nvarchar(260),
                                  [@fname57] nvarchar(260), [@fname58] nvarchar(260), [@fname59] nvarchar(260),
                                  [@fname6] nvarchar(260), [@fname60] nvarchar(260), [@fname61] nvarchar(260),
                                  [@fname62] nvarchar(260), [@fname63] nvarchar(260), [@fname64] nvarchar(260),
                                  [@fname7] nvarchar(260), [@fname8] nvarchar(260), [@fname9] nvarchar(260),
                                  [@seqnum] int, [@start] nvarchar(25)) as -- missing source code
go

create function sys.fn_dump_dblog_xtp([@devtype] nvarchar(260), [@end] nvarchar(25), [@fname1] nvarchar(260),
                                      [@fname10] nvarchar(260), [@fname11] nvarchar(260), [@fname12] nvarchar(260),
                                      [@fname13] nvarchar(260), [@fname14] nvarchar(260), [@fname15] nvarchar(260),
                                      [@fname16] nvarchar(260), [@fname17] nvarchar(260), [@fname18] nvarchar(260),
                                      [@fname19] nvarchar(260), [@fname2] nvarchar(260), [@fname20] nvarchar(260),
                                      [@fname21] nvarchar(260), [@fname22] nvarchar(260), [@fname23] nvarchar(260),
                                      [@fname24] nvarchar(260), [@fname25] nvarchar(260), [@fname26] nvarchar(260),
                                      [@fname27] nvarchar(260), [@fname28] nvarchar(260), [@fname29] nvarchar(260),
                                      [@fname3] nvarchar(260), [@fname30] nvarchar(260), [@fname31] nvarchar(260),
                                      [@fname32] nvarchar(260), [@fname33] nvarchar(260), [@fname34] nvarchar(260),
                                      [@fname35] nvarchar(260), [@fname36] nvarchar(260), [@fname37] nvarchar(260),
                                      [@fname38] nvarchar(260), [@fname39] nvarchar(260), [@fname4] nvarchar(260),
                                      [@fname40] nvarchar(260), [@fname41] nvarchar(260), [@fname42] nvarchar(260),
                                      [@fname43] nvarchar(260), [@fname44] nvarchar(260), [@fname45] nvarchar(260),
                                      [@fname46] nvarchar(260), [@fname47] nvarchar(260), [@fname48] nvarchar(260),
                                      [@fname49] nvarchar(260), [@fname5] nvarchar(260), [@fname50] nvarchar(260),
                                      [@fname51] nvarchar(260), [@fname52] nvarchar(260), [@fname53] nvarchar(260),
                                      [@fname54] nvarchar(260), [@fname55] nvarchar(260), [@fname56] nvarchar(260),
                                      [@fname57] nvarchar(260), [@fname58] nvarchar(260), [@fname59] nvarchar(260),
                                      [@fname6] nvarchar(260), [@fname60] nvarchar(260), [@fname61] nvarchar(260),
                                      [@fname62] nvarchar(260), [@fname63] nvarchar(260), [@fname64] nvarchar(260),
                                      [@fname7] nvarchar(260), [@fname8] nvarchar(260), [@fname9] nvarchar(260),
                                      [@seqnum] int, [@start] nvarchar(25)) as -- missing source code
go

create function sys.fn_fIsColTracked([@artnick] int) returns int as -- missing source code
go

create function sys.fn_full_dblog([@backup_account] nvarchar(260), [@backup_container] nvarchar(260), [@dbid] int,
                                  [@end] nvarchar(25), [@logical_dbid] nvarchar(260), [@page_fid] int, [@page_pid] int,
                                  [@start] nvarchar(25)) as -- missing source code
go

create function sys.fn_get_audit_file([@audit_record_offset] bigint, [@file_pattern] nvarchar(260),
                                      [@initial_file_name] nvarchar(260)) as -- missing source code
go

create function sys.fn_get_sql([@handle] varbinary(64)) as -- missing source code
go

create function sys.fn_hadr_backup_is_preferred_replica([@database_name] sysname) returns bit as -- missing source code
go

create function sys.fn_hadr_distributed_ag_database_replica([@database_id] uniqueidentifier, [@lag_id] uniqueidentifier) as -- missing source code
go

create function sys.fn_hadr_distributed_ag_replica([@lag_id] uniqueidentifier, [@replica_id] uniqueidentifier) as -- missing source code
go

create function sys.fn_hadr_is_primary_replica([@database_name] sysname) returns bit as -- missing source code
go

create function sys.fn_hadr_is_same_replica([@ag_replica_id] uniqueidentifier, [@lag_id] uniqueidentifier,
                                            [@lag_replica_id] uniqueidentifier) returns bit as -- missing source code
go

create function sys.fn_helpcollations() as -- missing source code
go

create function sys.fn_helpdatatypemap([@defaults_only] bit, [@destination_dbms] sysname, [@destination_type] sysname,
                                       [@destination_version] sysname, [@source_dbms] sysname, [@source_type] sysname,
                                       [@source_version] sysname) as -- missing source code
go

create function sys.fn_isrolemember([@login] sysname, [@mode] int, [@tranpubid] int) returns int as -- missing source code
go

create function sys.fn_listextendedproperty([@level0name] sysname, [@level0type] varchar(128), [@level1name] sysname,
                                            [@level1type] varchar(128), [@level2name] sysname,
                                            [@level2type] varchar(128), [@name] sysname) as -- missing source code
go

create function sys.fn_my_permissions([@class] nvarchar(60), [@entity] sysname) as -- missing source code
go

create function sys.fn_numberOf1InBinaryAfterLoc([@byte] binary(1), [@loc] int) returns int as -- missing source code
go

create function sys.fn_numberOf1InVarBinary([@bm] varbinary(128)) returns int as -- missing source code
go

create function sys.fn_repladjustcolumnmap([@inmap] varbinary(4000), [@objid] int, [@total_col] int) returns varbinary(4000) as -- missing source code
go

create function sys.fn_repldecryptver4([@password] nvarchar(524)) returns nvarchar(524) as -- missing source code
go

create function sys.fn_replformatdatetime([@datetime] datetime) returns nvarchar(50) as -- missing source code
go

create function sys.fn_replgetcolidfrombitmap([@columns] binary(32)) as -- missing source code
go

create function sys.fn_replgetparsedddlcmd([@FirstToken] sysname, [@dbname] sysname, [@ddlcmd] nvarchar(max),
                                           [@objectType] sysname, [@objname] sysname, [@owner] sysname,
                                           [@targetobject] nvarchar(512)) returns nvarchar(max) as -- missing source code
go

create function sys.fn_replp2pversiontotranid([@varbin] varbinary(32)) returns nvarchar(40) as -- missing source code
go

create function sys.fn_replreplacesinglequote([@pstrin] nvarchar(max)) returns nvarchar(max) as -- missing source code
go

create function sys.fn_replreplacesinglequoteplusprotectstring([@pstrin] nvarchar(4000)) returns nvarchar(4000) as -- missing source code
go

create function sys.fn_repluniquename([@guid] uniqueidentifier, [@prefix1] sysname, [@prefix2] sysname,
                                      [@prefix3] sysname,
                                      [@prefix4] sysname) returns nvarchar(100) as -- missing source code
go

create function sys.fn_replvarbintoint([@varbin] varbinary(32)) returns int as -- missing source code
go

create function sys.fn_servershareddrives() as -- missing source code
go

create function sys.fn_sqlagent_job_history([@job_id] uniqueidentifier, [@step_id] int) as -- missing source code
go

create function sys.fn_sqlagent_jobs([@job_id] uniqueidentifier) as -- missing source code
go

create function sys.fn_sqlagent_jobsteps([@job_id] uniqueidentifier, [@step_id] int) as -- missing source code
go

create function sys.fn_sqlagent_jobsteps_logs([@step_uid] uniqueidentifier) as -- missing source code
go

create function sys.fn_sqlagent_subsystems() as -- missing source code
go

create function sys.fn_sqlvarbasetostr([@ssvar] sql_variant) returns nvarchar(max) as -- missing source code
go

create function sys.fn_stmt_sql_handle_from_sql_stmt([@query_param_type] tinyint, [@query_sql_text] nvarchar(max)) as -- missing source code
go

create function sys.fn_trace_geteventinfo([@handle] int) as -- missing source code
go

create function sys.fn_trace_getfilterinfo([@handle] int) as -- missing source code
go

create function sys.fn_trace_getinfo([@handle] int) as -- missing source code
go

create function sys.fn_trace_gettable([@filename] nvarchar(4000), [@numfiles] int) as -- missing source code
go

create function sys.fn_translate_permissions([@level] nvarchar(60), [@perms] varbinary(16)) as -- missing source code
go

create function sys.fn_validate_plan_guide([@plan_guide_id] int) as -- missing source code
go

create function sys.fn_varbintohexstr([@pbinin] varbinary(max)) returns nvarchar(max) as -- missing source code
go

create function sys.fn_varbintohexsubstring([@cbytesin] int, [@fsetprefix] bit, [@pbinin] varbinary(max),
                                            [@startoffset] int) returns nvarchar(max) as -- missing source code
go

create function sys.fn_virtualfilestats([@DatabaseId] int, [@FileId] int) as -- missing source code
go

create function sys.fn_virtualservernodes() as -- missing source code
go

create function sys.fn_xe_file_target_read_file([@initial_file_name] nvarchar(260), [@initial_offset] bigint,
                                                [@mdpath] nvarchar(260),
                                                [@path] nvarchar(260)) as -- missing source code
go

create function sys.fn_yukonsecuritymodelrequired([@username] sysname) returns bit as -- missing source code
go

create procedure sys.sp_AddFunctionalUnitToComponent() as -- missing source code
go

create procedure sys.sp_FuzzyLookupTableMaintenanceInstall([@etiTableName] nvarchar(1024)) as -- missing source code
go

create procedure sys.sp_FuzzyLookupTableMaintenanceInvoke([@etiTableName] nvarchar(1024)) as -- missing source code
go

create procedure sys.sp_FuzzyLookupTableMaintenanceUninstall([@etiTableName] nvarchar(1024)) as -- missing source code
go

create procedure sys.sp_IHScriptIdxFile([@article_id] int) as -- missing source code
go

create procedure sys.sp_IHScriptSchFile([@article_id] int) as -- missing source code
go

create procedure sys.sp_IHValidateRowFilter([@columnmask] binary(128), [@owner] sysname, [@publisher] sysname,
                                            [@rowfilter] nvarchar(max), [@table] sysname) as -- missing source code
go

create procedure sys.sp_IHXactSetJob([@LRinterval] int, [@LRthreshold] int, [@enabled] bit, [@interval] int,
                                     [@publisher] sysname, [@threshold] int) as -- missing source code
go

create procedure sys.sp_IH_LR_GetCacheData([@publisher] sysname) as -- missing source code
go

create procedure sys.sp_IHadd_sync_command([@article_id] int, [@command] varbinary(1024), [@command_id] int,
                                           [@originator] sysname, [@originator_db] sysname, [@partial_command] bit,
                                           [@publisher] sysname, [@publisher_db] sysname, [@publisher_id] smallint,
                                           [@type] int, [@xact_id] varbinary(16),
                                           [@xact_seqno] varbinary(16)) as -- missing source code
go

create procedure sys.sp_IHarticlecolumn([@article] sysname, [@change_active] int, [@column] sysname,
                                        [@force_invalidate_snapshot] bit, [@force_reinit_subscription] bit,
                                        [@ignore_distributor] bit, [@operation] nvarchar(4), [@publication] sysname,
                                        [@publisher] sysname, [@publisher_dbms] sysname, [@publisher_type] sysname,
                                        [@publisher_version] sysname,
                                        [@refresh_synctran_procs] bit) as -- missing source code
go

create procedure sys.sp_IHget_loopback_detection([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                 [@subscriber] sysname,
                                                 [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSCleanupForPullReinit([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSFixSubColumnBitmaps([@artid] uniqueidentifier, [@bm] varbinary(128)) as -- missing source code
go

create procedure sys.sp_MSGetCurrentPrincipal([@current_principal] sysname, [@db_name] sysname) as -- missing source code
go

create procedure sys.sp_MSGetServerProperties() as -- missing source code
go

create procedure sys.sp_MSIfExistsSubscription([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                               [@type] int) as -- missing source code
go

create procedure sys.sp_MSNonSQLDDL([@columnName] sysname, [@pubid] uniqueidentifier,
                                    [@qual_source_object] nvarchar(540), [@schemasubtype] int) as -- missing source code
go

create procedure sys.sp_MSNonSQLDDLForSchemaDDL([@artid] uniqueidentifier, [@ddlcmd] nvarchar(max),
                                                [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSSQLDMO70_version() as -- missing source code
go

create procedure sys.sp_MSSQLDMO80_version() as -- missing source code
go

create procedure sys.sp_MSSQLDMO90_version() as -- missing source code
go

create procedure sys.sp_MSSQLOLE65_version() as -- missing source code
go

create procedure sys.sp_MSSQLOLE_version() as -- missing source code
go

create procedure sys.sp_MSSetServerProperties([@auto_start] int) as -- missing source code
go

create procedure sys.sp_MSSharedFixedDisk() as -- missing source code
go

create procedure sys.sp_MS_marksystemobject([@namespace] varchar(10), [@objname] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MS_replication_installed() as -- missing source code
go

create procedure sys.sp_MSacquireHeadofQueueLock([@DbPrincipal] sysname, [@no_result] bit, [@process_name] sysname,
                                                 [@queue_timeout] int,
                                                 [@return_immediately] bit) as -- missing source code
go

create procedure sys.sp_MSacquireSlotLock([@DbPrincipal] sysname, [@concurrent_max] int, [@process_name] sysname,
                                          [@queue_timeout] int, [@return_immediately] bit) as -- missing source code
go

create procedure sys.sp_MSacquireserverresourcefordynamicsnapshot([@max_concurrent_dynamic_snapshots] int, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSacquiresnapshotdeliverysessionlock() as -- missing source code
go

create procedure sys.sp_MSactivate_auto_sub([@article] sysname, [@publication] sysname, [@publisher] sysname,
                                            [@skipobjectactivation] int, [@status] sysname) as -- missing source code
go

create procedure sys.sp_MSactivatelogbasedarticleobject([@qualified_logbased_object_name] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MSactivateprocedureexecutionarticleobject([@is_repl_serializable_only] bit,
                                                                  [@qualified_procedure_execution_object_name] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MSadd_anonymous_agent([@agent_id] int, [@anonymous_subid] uniqueidentifier,
                                              [@publication] sysname, [@publisher_db] sysname, [@publisher_id] int,
                                              [@reinitanon] bit, [@subscriber_db] sysname,
                                              [@subscriber_name] sysname) as -- missing source code
go

create procedure sys.sp_MSadd_article([@article] sysname, [@article_id] int, [@description] nvarchar(255),
                                      [@destination_object] sysname, [@destination_owner] sysname, [@internal] sysname,
                                      [@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                      [@source_object] sysname, [@source_owner] sysname) as -- missing source code
go

create procedure sys.sp_MSadd_compensating_cmd([@article_id] int, [@cmdstate] bit, [@command] nvarchar(max),
                                               [@mode] int, [@orig_db] sysname, [@orig_srv] sysname,
                                               [@publication_id] int, [@setprefix] bit) as -- missing source code
go

create procedure sys.sp_MSadd_distribution_agent([@active_end_date] int, [@active_end_time_of_day] int,
                                                 [@active_start_date] int, [@active_start_time_of_day] int,
                                                 [@agent_id] int, [@command] nvarchar(4000),
                                                 [@distribution_jobid] binary(16), [@dts_package_location] int,
                                                 [@dts_package_name] sysname, [@dts_package_password] nvarchar(524),
                                                 [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                                 [@frequency_relative_interval] int, [@frequency_subday] int,
                                                 [@frequency_subday_interval] int, [@frequency_type] int,
                                                 [@internal] sysname, [@job_login] nvarchar(257),
                                                 [@job_password] sysname, [@local_job] bit, [@name] sysname,
                                                 [@offloadagent] bit, [@offloadserver] sysname, [@publication] sysname,
                                                 [@publisher_db] sysname, [@publisher_id] smallint,
                                                 [@retryattempts] int, [@retrydelay] int, [@subscriber_catalog] sysname,
                                                 [@subscriber_datasrc] nvarchar(4000), [@subscriber_db] sysname,
                                                 [@subscriber_id] smallint, [@subscriber_location] nvarchar(4000),
                                                 [@subscriber_login] sysname, [@subscriber_password] nvarchar(524),
                                                 [@subscriber_provider] sysname,
                                                 [@subscriber_provider_string] nvarchar(4000),
                                                 [@subscriber_security_mode] smallint, [@subscription_type] int,
                                                 [@update_mode] int) as -- missing source code
go

create procedure sys.sp_MSadd_distribution_history([@agent_id] int, [@command_id] int, [@comments] nvarchar(max),
                                                   [@delivered_commands] int, [@delivered_transactions] int,
                                                   [@delivery_rate] float, [@do_raiserror] bit, [@log_error] bit,
                                                   [@perfmon_increment] bit, [@runstatus] int,
                                                   [@update_existing_row] bit, [@updateable_row] bit,
                                                   [@xact_seqno] binary(16),
                                                   [@xactseq] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSadd_dynamic_snapshot_location([@dynsnap_location] nvarchar(255), [@partition_id] int,
                                                        [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSadd_filteringcolumn([@column_name] sysname, [@pubid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSadd_log_shipping_error_detail([@agent_id] uniqueidentifier, [@agent_type] tinyint,
                                                        [@database] sysname, [@help_url] nvarchar(4000),
                                                        [@message] nvarchar(4000), [@sequence_number] int,
                                                        [@session_id] int,
                                                        [@source] nvarchar(4000)) as -- missing source code
go

create procedure sys.sp_MSadd_log_shipping_history_detail([@agent_id] uniqueidentifier, [@agent_type] tinyint,
                                                          [@database] sysname,
                                                          [@last_processed_file_name] nvarchar(500),
                                                          [@message] nvarchar(4000), [@session_id] int,
                                                          [@session_status] tinyint) as -- missing source code
go

create procedure sys.sp_MSadd_logreader_agent([@internal] sysname, [@job_existing] bit, [@job_id] binary(16),
                                              [@job_login] nvarchar(257), [@job_password] sysname, [@local_job] bit,
                                              [@name] nvarchar(100), [@publication] sysname, [@publisher] sysname,
                                              [@publisher_db] sysname, [@publisher_engine_edition] int,
                                              [@publisher_login] sysname, [@publisher_password] nvarchar(524),
                                              [@publisher_security_mode] smallint,
                                              [@publisher_type] sysname) as -- missing source code
go

create procedure sys.sp_MSadd_logreader_history([@agent_id] int, [@comments] nvarchar(4000), [@delivered_commands] int,
                                                [@delivered_transactions] int, [@delivery_latency] int,
                                                [@delivery_time] int, [@do_raiserror] bit, [@log_error] bit,
                                                [@perfmon_increment] bit, [@runstatus] int, [@update_existing_row] bit,
                                                [@updateable_row] bit,
                                                [@xact_seqno] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSadd_merge_agent([@active_end_date] int, [@active_end_time_of_day] int,
                                          [@active_start_date] int, [@active_start_time_of_day] int,
                                          [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                          [@frequency_relative_interval] int, [@frequency_subday] int,
                                          [@frequency_subday_interval] int, [@frequency_type] int, [@hostname] sysname,
                                          [@internal] sysname, [@job_login] nvarchar(257), [@job_password] sysname,
                                          [@local_job] bit, [@merge_jobid] binary(16), [@name] sysname,
                                          [@offloadagent] bit, [@offloadserver] sysname,
                                          [@optional_command_line] nvarchar(255), [@publication] sysname,
                                          [@publisher] sysname, [@publisher_db] sysname,
                                          [@publisher_engine_edition] int, [@publisher_login] sysname,
                                          [@publisher_password] nvarchar(524), [@publisher_security_mode] smallint,
                                          [@subscriber] sysname, [@subscriber_db] sysname, [@subscriber_login] sysname,
                                          [@subscriber_password] nvarchar(524), [@subscriber_security_mode] smallint,
                                          [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MSadd_merge_anonymous_agent([@first_anonymous] int, [@publication] sysname,
                                                    [@publisher_db] sysname, [@publisher_engine_edition] int,
                                                    [@publisher_id] smallint, [@subid] uniqueidentifier,
                                                    [@subscriber_db] sysname, [@subscriber_name] sysname,
                                                    [@subscriber_version] int) as -- missing source code
go

create procedure sys.sp_MSadd_merge_history([@agent_id] int, [@called_by_nonlogged_shutdown_detection_agent] bit,
                                            [@comments] nvarchar(1000), [@delivery_time] int, [@do_raiserror] bit,
                                            [@download_conflicts] int, [@download_deletes] int, [@download_inserts] int,
                                            [@download_updates] int, [@log_error] bit, [@perfmon_increment] bit,
                                            [@runstatus] int, [@session_id_override] int, [@update_existing_row] bit,
                                            [@updateable_row] bit, [@upload_conflicts] int, [@upload_deletes] int,
                                            [@upload_inserts] int, [@upload_updates] int) as -- missing source code
go

create procedure sys.sp_MSadd_merge_history90([@agent_id] int, [@article_conflicts] int, [@article_deletes] int,
                                              [@article_estimated_changes] int, [@article_inserts] int,
                                              [@article_name] sysname, [@article_percent_complete] decimal(5, 2),
                                              [@article_relative_cost] decimal(12, 2), [@article_rows_retried] int,
                                              [@article_updates] int, [@comments] nvarchar(1000),
                                              [@connection_type] int, [@delivery_rate] decimal(12, 2),
                                              [@delivery_time] int, [@download_time] int, [@info_filter] int,
                                              [@log_error] bit, [@phase_id] int, [@prepare_snapshot_time] int,
                                              [@runstatus] int, [@schema_change_time] int, [@session_bulk_inserts] int,
                                              [@session_download_conflicts] int, [@session_download_deletes] int,
                                              [@session_download_inserts] int, [@session_download_rows_retried] int,
                                              [@session_download_updates] int, [@session_duration] int,
                                              [@session_estimated_download_changes] int,
                                              [@session_estimated_upload_changes] int, [@session_id] int,
                                              [@session_metadata_rows_cleanedup] int,
                                              [@session_percent_complete] decimal(5, 2), [@session_schema_changes] int,
                                              [@session_upload_conflicts] int, [@session_upload_deletes] int,
                                              [@session_upload_inserts] int, [@session_upload_rows_retried] int,
                                              [@session_upload_updates] int, [@subid] uniqueidentifier,
                                              [@time_remaining] int, [@update_existing_row] bit, [@update_stats] bit,
                                              [@updateable_row] bit, [@upload_time] int) as -- missing source code
go

create procedure sys.sp_MSadd_merge_subscription([@active_end_date] int, [@active_end_time_of_day] int,
                                                 [@active_start_date] int, [@active_start_time_of_day] int,
                                                 [@agent_name] sysname, [@description] nvarchar(255),
                                                 [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                                 [@frequency_relative_interval] int, [@frequency_subday] int,
                                                 [@frequency_subday_interval] int, [@frequency_type] int,
                                                 [@hostname] sysname, [@internal] sysname, [@merge_jobid] binary(16),
                                                 [@offloadagent] bit, [@offloadserver] sysname,
                                                 [@optional_command_line] nvarchar(4000), [@publication] sysname,
                                                 [@publisher] sysname, [@publisher_db] sysname,
                                                 [@publisher_engine_edition] int, [@status] tinyint,
                                                 [@subid] uniqueidentifier, [@subscriber] sysname,
                                                 [@subscriber_db] sysname, [@subscription_type] tinyint,
                                                 [@sync_type] tinyint) as -- missing source code
go

create procedure sys.sp_MSadd_mergereplcommand([@article] sysname, [@publication] sysname, [@schematext] nvarchar(2000),
                                               [@schematype] int, [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSadd_mergesubentry_indistdb([@description] nvarchar(255), [@publication] sysname,
                                                     [@publisher] sysname, [@publisher_db] sysname,
                                                     [@publisher_id] smallint, [@status] tinyint,
                                                     [@subid] uniqueidentifier, [@subscriber] sysname,
                                                     [@subscriber_db] sysname, [@subscriber_version] int,
                                                     [@subscription_type] tinyint,
                                                     [@sync_type] tinyint) as -- missing source code
go

create procedure sys.sp_MSadd_publication([@allow_anonymous] bit, [@allow_initialize_from_backup] bit,
                                          [@allow_pull] bit, [@allow_push] bit, [@allow_queued_tran] bit,
                                          [@allow_subscription_copy] bit, [@description] nvarchar(255),
                                          [@immediate_sync] bit, [@independent_agent] bit,
                                          [@logreader_agent] nvarchar(100), [@options] int, [@publication] sysname,
                                          [@publication_id] int, [@publication_type] int, [@publisher] sysname,
                                          [@publisher_db] sysname, [@publisher_engine_edition] int,
                                          [@publisher_type] sysname, [@queue_type] int, [@retention] int,
                                          [@retention_period_unit] tinyint, [@snapshot_agent] nvarchar(100),
                                          [@sync_method] int, [@thirdparty_options] int,
                                          [@vendor_name] nvarchar(100)) as -- missing source code
go

create procedure sys.sp_MSadd_qreader_agent([@agent_id] int, [@agent_jobid] binary(16), [@internal] sysname,
                                            [@job_login] nvarchar(257), [@job_password] sysname,
                                            [@name] nvarchar(100)) as -- missing source code
go

create procedure sys.sp_MSadd_qreader_history([@agent_id] int, [@commands_processed] int, [@comments] nvarchar(1000),
                                              [@do_raiserror] bit, [@log_error] bit, [@perfmon_increment] bit,
                                              [@pubid] int, [@runstatus] int, [@seconds_elapsed] int,
                                              [@subscriber] sysname, [@subscriberdb] sysname,
                                              [@transaction_id] nvarchar(40), [@transaction_status] int,
                                              [@transactions_processed] int,
                                              [@update_existing_row] bit) as -- missing source code
go

create procedure sys.sp_MSadd_repl_alert([@agent_id] int, [@agent_type] int, [@alert_error_code] int,
                                         [@alert_error_text] nvarchar(max), [@command_id] int, [@error_id] int,
                                         [@publisher] sysname, [@publisher_db] sysname, [@subscriber] sysname,
                                         [@subscriber_db] sysname,
                                         [@xact_seqno] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSadd_repl_command([@article_id] int, [@command] varbinary(1024), [@command_id] int,
                                           [@originator] sysname, [@originator_db] sysname, [@partial_command] bit,
                                           [@publisher] sysname, [@publisher_db] sysname, [@publisher_id] smallint,
                                           [@type] int, [@xact_id] varbinary(16),
                                           [@xact_seqno] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSadd_repl_commands27hp([@10data] varbinary(1575), [@11data] varbinary(1575),
                                                [@12data] varbinary(1575), [@13data] varbinary(1575),
                                                [@14data] varbinary(1575), [@15data] varbinary(1575),
                                                [@16data] varbinary(1575), [@17data] varbinary(1575),
                                                [@18data] varbinary(1575), [@19data] varbinary(1575),
                                                [@1data] varbinary(1575), [@20data] varbinary(1575),
                                                [@21data] varbinary(1575), [@22data] varbinary(1575),
                                                [@23data] varbinary(1575), [@24data] varbinary(1575),
                                                [@25data] varbinary(1575), [@26data] varbinary(1575),
                                                [@2data] varbinary(1575), [@3data] varbinary(1575),
                                                [@4data] varbinary(1575), [@5data] varbinary(1575),
                                                [@6data] varbinary(1575), [@7data] varbinary(1575),
                                                [@8data] varbinary(1575), [@9data] varbinary(1575),
                                                [@data] varbinary(1575), [@publisher_db] sysname,
                                                [@publisher_id] smallint) as -- missing source code
go

create procedure sys.sp_MSadd_repl_error([@add_event_log] int, [@error_code] sysname, [@error_text] nvarchar(max),
                                         [@error_type_id] int, [@event_log_context] nvarchar(max), [@id] int,
                                         [@map_source_type] bit, [@session_id] int, [@source_name] sysname,
                                         [@source_type_id] int) as -- missing source code
go

create procedure sys.sp_MSadd_replcmds_mcit([@10data] varbinary(1595), [@11data] varbinary(1595),
                                            [@12data] varbinary(1595), [@13data] varbinary(1595),
                                            [@14data] varbinary(1595), [@15data] varbinary(1595),
                                            [@16data] varbinary(1595), [@17data] varbinary(1595),
                                            [@18data] varbinary(1595), [@19data] varbinary(1595),
                                            [@1data] varbinary(1595), [@20data] varbinary(1595),
                                            [@21data] varbinary(1595), [@22data] varbinary(1595),
                                            [@23data] varbinary(1595), [@24data] varbinary(1595),
                                            [@25data] varbinary(1595), [@26data] varbinary(1595),
                                            [@2data] varbinary(1595), [@3data] varbinary(1595),
                                            [@4data] varbinary(1595), [@5data] varbinary(1595),
                                            [@6data] varbinary(1595), [@7data] varbinary(1595),
                                            [@8data] varbinary(1595), [@9data] varbinary(1595), [@data] varbinary(1595),
                                            [@publisher_database_id] int, [@publisher_db] sysname,
                                            [@publisher_id] smallint) as -- missing source code
go

create procedure sys.sp_MSadd_replmergealert([@agent_id] int, [@agent_type] int, [@alert_error_code] int,
                                             [@alert_error_text] nvarchar(max), [@article] sysname,
                                             [@destination_object] sysname, [@error_id] int, [@publication] sysname,
                                             [@publication_type] int, [@publisher] sysname, [@publisher_db] sysname,
                                             [@source_object] sysname, [@subscriber] sysname,
                                             [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSadd_snapshot_agent([@activeenddate] int, [@activeendtimeofday] int, [@activestartdate] int,
                                             [@activestarttimeofday] int, [@command] nvarchar(4000),
                                             [@freqinterval] int, [@freqrecurrencefactor] int,
                                             [@freqrelativeinterval] int, [@freqsubinterval] int, [@freqsubtype] int,
                                             [@freqtype] int, [@internal] sysname, [@job_existing] bit,
                                             [@job_login] nvarchar(257), [@job_password] sysname, [@local_job] bit,
                                             [@name] nvarchar(100), [@publication] sysname, [@publication_type] int,
                                             [@publisher] sysname, [@publisher_db] sysname, [@publisher_login] sysname,
                                             [@publisher_password] nvarchar(524), [@publisher_security_mode] smallint,
                                             [@publisher_type] sysname,
                                             [@snapshot_jobid] binary(16)) as -- missing source code
go

create procedure sys.sp_MSadd_snapshot_history([@agent_id] int, [@comments] nvarchar(1000), [@delivered_commands] int,
                                               [@delivered_transactions] int, [@do_raiserror] bit, [@duration] int,
                                               [@log_error] bit, [@perfmon_increment] bit, [@runstatus] int,
                                               [@start_time_string] nvarchar(25),
                                               [@update_existing_row] bit) as -- missing source code
go

create procedure sys.sp_MSadd_subscriber_info([@active_end_date] int, [@active_end_time_of_day] int,
                                              [@active_start_date] int, [@active_start_time_of_day] int,
                                              [@commit_batch_size] int, [@description] nvarchar(255),
                                              [@encrypted_password] bit, [@flush_frequency] int,
                                              [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                              [@frequency_relative_interval] int, [@frequency_subday] int,
                                              [@frequency_subday_interval] int, [@frequency_type] int,
                                              [@internal] sysname, [@login] sysname, [@password] nvarchar(524),
                                              [@publisher] sysname, [@retryattempts] int, [@retrydelay] int,
                                              [@security_mode] int, [@status_batch_size] int, [@subscriber] sysname,
                                              [@type] tinyint) as -- missing source code
go

create procedure sys.sp_MSadd_subscriber_schedule([@active_end_date] int, [@active_end_time_of_day] int,
                                                  [@active_start_date] int, [@active_start_time_of_day] int,
                                                  [@agent_type] smallint, [@frequency_interval] int,
                                                  [@frequency_recurrence_factor] int,
                                                  [@frequency_relative_interval] int, [@frequency_subday] int,
                                                  [@frequency_subday_interval] int, [@frequency_type] int,
                                                  [@publisher] sysname, [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_MSadd_subscription([@active_end_date] int, [@active_end_time_of_day] int,
                                           [@active_start_date] int, [@active_start_time_of_day] int,
                                           [@article] sysname, [@article_id] int, [@distribution_job_name] sysname,
                                           [@distribution_jobid] binary(16), [@dts_package_location] int,
                                           [@dts_package_name] sysname, [@dts_package_password] nvarchar(524),
                                           [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                           [@frequency_relative_interval] int, [@frequency_subday] int,
                                           [@frequency_subday_interval] int, [@frequency_type] int, [@internal] sysname,
                                           [@loopback_detection] bit, [@nosync_type] tinyint, [@offloadagent] bit,
                                           [@offloadserver] sysname, [@optional_command_line] nvarchar(4000),
                                           [@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                           [@publisher_engine_edition] int, [@snapshot_seqno_flag] bit,
                                           [@status] tinyint, [@subscriber] sysname, [@subscriber_db] sysname,
                                           [@subscription_seqno] varbinary(16), [@subscription_type] tinyint,
                                           [@sync_type] tinyint, [@update_mode] tinyint) as -- missing source code
go

create procedure sys.sp_MSadd_subscription_3rd([@active_end_date] int, [@active_end_time_of_day] int,
                                               [@active_start_date] int, [@active_start_time_of_day] int,
                                               [@distribution_jobid] binary(8), [@frequency_interval] int,
                                               [@frequency_recurrence_factor] int, [@frequency_relative_interval] int,
                                               [@frequency_subday] int, [@frequency_subday_interval] int,
                                               [@frequency_type] int, [@publication] sysname, [@publisher] sysname,
                                               [@publisher_db] sysname, [@status] tinyint, [@subscriber] sysname,
                                               [@subscriber_db] sysname, [@subscription_type] tinyint,
                                               [@sync_type] tinyint) as -- missing source code
go

create procedure sys.sp_MSadd_tracer_history([@tracer_id] int) as -- missing source code
go

create procedure sys.sp_MSadd_tracer_token([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                           [@subscribers_found] bit, [@tracer_id] int) as -- missing source code
go

create procedure sys.sp_MSaddanonymousreplica([@anonymous] int, [@preexists] bit, [@publication] sysname,
                                              [@publisher] sysname, [@publisherDB] sysname,
                                              [@sync_type] int) as -- missing source code
go

create procedure sys.sp_MSadddynamicsnapshotjobatdistributor([@activeenddate] int, [@activeendtimeofday] int,
                                                             [@activestartdate] int, [@activestarttimeofday] int,
                                                             [@dynamic_filter_hostname] sysname,
                                                             [@dynamic_filter_login] sysname,
                                                             [@dynamic_snapshot_agent_id] int,
                                                             [@dynamic_snapshot_job_step_uid] uniqueidentifier,
                                                             [@dynamic_snapshot_jobid] uniqueidentifier,
                                                             [@dynamic_snapshot_jobname] nvarchar(128),
                                                             [@dynamic_snapshot_location] nvarchar(255),
                                                             [@freqinterval] int, [@freqrecurrencefactor] int,
                                                             [@freqrelativeinterval] int, [@freqsubinterval] int,
                                                             [@freqsubtype] int, [@freqtype] int, [@partition_id] int,
                                                             [@regular_snapshot_jobid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSaddguidcolumn([@source_owner] sysname, [@source_table] sysname) as -- missing source code
go

create procedure sys.sp_MSaddguidindex([@publication] sysname, [@source_owner] sysname,
                                       [@source_table] sysname) as -- missing source code
go

create procedure sys.sp_MSaddinitialarticle([@article] sysname, [@article_resolver] nvarchar(255),
                                            [@artid] uniqueidentifier, [@column_tracking] int,
                                            [@compensate_for_errors] bit, [@delete_tracking] bit,
                                            [@destination_object] sysname, [@destination_owner] sysname,
                                            [@excluded_cols] varbinary(128), [@excluded_count] int,
                                            [@fast_multicol_updateproc] bit, [@filter_clause] nvarchar(2000),
                                            [@identity_range] bigint, [@identity_support] int,
                                            [@insert_proc] nvarchar(255),
                                            [@logical_record_level_conflict_detection] bit,
                                            [@logical_record_level_conflict_resolution] bit,
                                            [@missing_cols] varbinary(128), [@missing_count] int, [@nickname] int,
                                            [@partition_options] tinyint, [@pre_creation_command] int,
                                            [@preserve_rowguidcol] bit, [@processing_order] int,
                                            [@pub_identity_range] bigint, [@pubid] uniqueidentifier,
                                            [@published_in_tran_pub] bit, [@resolver_clsid] nvarchar(255),
                                            [@resolver_info] nvarchar(517), [@select_proc] nvarchar(255), [@status] int,
                                            [@stream_blob_columns] bit, [@threshold] int, [@update_proc] nvarchar(255),
                                            [@upload_options] tinyint,
                                            [@verify_resolver_signature] int) as -- missing source code
go

create procedure sys.sp_MSaddinitialpublication([@allow_anonymous] int, [@allow_pull] int, [@allow_push] int,
                                                [@allow_subscription_copy] int, [@allow_synctoalternate] int,
                                                [@automatic_reinitialization_policy] bit, [@backward_comp_level] int,
                                                [@conflict_logging] int, [@conflict_retention] int,
                                                [@description] nvarchar(255), [@enabled_for_internet] int,
                                                [@generation_leveling_threshold] int, [@pubid] uniqueidentifier,
                                                [@publication] sysname, [@publication_type] int, [@publisher] sysname,
                                                [@publisher_db] sysname, [@replicate_ddl] int,
                                                [@replnickname] binary(6), [@retention] int,
                                                [@retention_period_unit] tinyint, [@snapshot_ready] int, [@status] int,
                                                [@sync_mode] int) as -- missing source code
go

create procedure sys.sp_MSaddinitialschemaarticle([@artid] uniqueidentifier, [@destination_object] sysname,
                                                  [@destination_owner] sysname, [@name] sysname,
                                                  [@pre_creation_command] tinyint, [@pubid] uniqueidentifier,
                                                  [@status] int, [@type] tinyint) as -- missing source code
go

create procedure sys.sp_MSaddinitialsubscription([@distributor] sysname, [@pubid] uniqueidentifier,
                                                 [@publication] sysname, [@replica_version] int,
                                                 [@replicastate] uniqueidentifier, [@subid] uniqueidentifier,
                                                 [@subscriber] sysname, [@subscriber_db] sysname,
                                                 [@subscriber_priority] real, [@subscriber_type] tinyint,
                                                 [@subscription_type] int,
                                                 [@sync_type] tinyint) as -- missing source code
go

create procedure sys.sp_MSaddlightweightmergearticle([@article_name] sysname, [@artid] uniqueidentifier,
                                                     [@column_tracking] bit, [@compensate_for_errors] bit,
                                                     [@delete_tracking] bit, [@destination_object] sysname,
                                                     [@destination_owner] sysname, [@identity_support] int,
                                                     [@processing_order] int, [@pubid] uniqueidentifier, [@status] int,
                                                     [@stream_blob_columns] bit, [@tablenick] int,
                                                     [@upload_options] tinyint,
                                                     [@well_partitioned] bit) as -- missing source code
go

create procedure sys.sp_MSaddmergedynamicsnapshotjob([@active_end_date] int, [@active_end_time_of_day] int,
                                                     [@active_start_date] int, [@active_start_time_of_day] int,
                                                     [@dynamic_filter_hostname] sysname,
                                                     [@dynamic_filter_login] sysname,
                                                     [@dynamic_job_step_uid] uniqueidentifier,
                                                     [@dynamic_snapshot_agentid] int,
                                                     [@dynamic_snapshot_jobid] uniqueidentifier,
                                                     [@dynamic_snapshot_jobname] sysname,
                                                     [@dynamic_snapshot_location] nvarchar(255),
                                                     [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                                     [@frequency_relative_interval] int, [@frequency_subday] int,
                                                     [@frequency_subday_interval] int, [@frequency_type] int,
                                                     [@ignore_select] bit,
                                                     [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSaddmergetriggers([@column_tracking] int, [@recreate_repl_views] bit,
                                           [@source_table] nvarchar(517),
                                           [@table_owner] sysname) as -- missing source code
go

create procedure sys.sp_MSaddmergetriggers_from_template([@column_tracking] int, [@genhistory_viewname] sysname,
                                                         [@max_colv_size_in_bytes_str] nvarchar(15),
                                                         [@replnick] binary(6), [@rgcol] sysname,
                                                         [@source_table] nvarchar(270), [@table_owner] sysname,
                                                         [@tablenickstr] nvarchar(15), [@trigger_type] tinyint,
                                                         [@trigname] sysname, [@tsview] sysname,
                                                         [@viewname] sysname) as -- missing source code
go

create procedure sys.sp_MSaddmergetriggers_internal([@column_tracking] int, [@current_mappings_viewname] sysname,
                                                    [@genhistory_viewname] sysname, [@past_mappings_viewname] sysname,
                                                    [@source_table] sysname, [@table_owner] sysname,
                                                    [@trigger_type] tinyint, [@trigname] sysname, [@tsview] sysname,
                                                    [@viewname] sysname) as -- missing source code
go

create procedure sys.sp_MSaddpeerlsn([@originator] sysname, [@originator_db] sysname, [@originator_db_version] int,
                                     [@originator_id] int, [@originator_lsn] varbinary(10),
                                     [@originator_publication] sysname, [@originator_publication_id] int,
                                     [@originator_version] int) as -- missing source code
go

create procedure sys.sp_MSaddsubscriptionarticles([@article] sysname, [@artid] int, [@dest_owner] sysname,
                                                  [@dest_table] sysname, [@publication] sysname, [@publisher] sysname,
                                                  [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSadjust_pub_identity([@current_max] bigint, [@next_seed] bigint, [@pub_range] bigint,
                                              [@publisher] sysname, [@publisher_db] sysname, [@range] bigint,
                                              [@tablename] sysname, [@threshold] int) as -- missing source code
go

create procedure sys.sp_MSagent_retry_stethoscope() as -- missing source code
go

create procedure sys.sp_MSagent_stethoscope([@heartbeat_interval] int) as -- missing source code
go

create procedure sys.sp_MSallocate_new_identity_range([@artid] uniqueidentifier, [@next_range_begin] numeric(38),
                                                      [@next_range_end] numeric(38), [@publication] sysname,
                                                      [@range_begin] numeric(38), [@range_end] numeric(38),
                                                      [@range_type] tinyint, [@ranges_needed] tinyint,
                                                      [@subid] uniqueidentifier, [@subscriber] sysname,
                                                      [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSalreadyhavegeneration([@compatlevel] int, [@genguid] uniqueidentifier,
                                                [@subscribernick] binary(6)) as -- missing source code
go

create procedure sys.sp_MSanonymous_status([@agent_id] int, [@last_xact_seqno] varbinary(16),
                                           [@no_init_sync] int) as -- missing source code
go

create procedure sys.sp_MSarticlecleanup([@artid] uniqueidentifier, [@force_preserve_rowguidcol] bit,
                                         [@ignore_merge_metadata] bit,
                                         [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSbrowsesnapshotfolder([@article_id] int, [@publisher] sysname, [@publisher_db] sysname,
                                               [@subscriber] sysname,
                                               [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MScache_agent_parameter([@parameter_name] sysname, [@parameter_value] nvarchar(255),
                                                [@profile_name] sysname) as -- missing source code
go

create procedure sys.sp_MScdc_capture_job() as -- missing source code
go

create procedure sys.sp_MScdc_cleanup_job() as -- missing source code
go

create procedure sys.sp_MScdc_db_ddl_event([@EventData] xml) as -- missing source code
go

create procedure sys.sp_MScdc_ddl_event([@EventData] xml) as -- missing source code
go

create procedure sys.sp_MScdc_logddl([@commit_lsn] binary(10), [@ddl_command] nvarchar(max), [@ddl_lsn] binary(10),
                                     [@ddl_time] nvarchar(1000), [@fis_alter_column] bit, [@fis_drop_table] bit,
                                     [@source_column_id] int, [@source_object_id] int) as -- missing source code
go

create procedure sys.sp_MSchange_article([@article] sysname, [@article_id] int, [@property] nvarchar(20),
                                         [@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                         [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_MSchange_distribution_agent_properties([@property] sysname, [@publication] sysname,
                                                               [@publisher] sysname, [@publisher_db] sysname,
                                                               [@subscriber] sysname, [@subscriber_db] sysname,
                                                               [@value] nvarchar(524)) as -- missing source code
go

create procedure sys.sp_MSchange_logreader_agent_properties([@job_login] nvarchar(257), [@job_password] sysname,
                                                            [@publisher] sysname, [@publisher_db] sysname,
                                                            [@publisher_login] sysname,
                                                            [@publisher_password] nvarchar(524),
                                                            [@publisher_security_mode] int,
                                                            [@publisher_type] sysname) as -- missing source code
go

create procedure sys.sp_MSchange_merge_agent_properties([@property] sysname, [@publication] sysname,
                                                        [@publisher] sysname, [@publisher_db] sysname,
                                                        [@subscriber] sysname, [@subscriber_db] sysname,
                                                        [@value] nvarchar(524)) as -- missing source code
go

create procedure sys.sp_MSchange_mergearticle([@artid] uniqueidentifier, [@property] sysname, [@pubid] uniqueidentifier,
                                              [@value] nvarchar(2000), [@value_numeric] int) as -- missing source code
go

create procedure sys.sp_MSchange_mergepublication([@property] sysname, [@pubid] uniqueidentifier,
                                                  [@value] nvarchar(2000)) as -- missing source code
go

create procedure sys.sp_MSchange_originatorid([@originator_db] sysname, [@originator_db_version] int,
                                              [@originator_id] int, [@originator_node] sysname,
                                              [@originator_publication] sysname, [@originator_publication_id] int,
                                              [@originator_version] int) as -- missing source code
go

create procedure sys.sp_MSchange_priority([@subid] uniqueidentifier, [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_MSchange_publication([@property] sysname, [@publication] sysname, [@publisher] sysname,
                                             [@publisher_db] sysname, [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_MSchange_retention([@pubid] uniqueidentifier, [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_MSchange_retention_period_unit([@pubid] uniqueidentifier, [@value] tinyint) as -- missing source code
go

create procedure sys.sp_MSchange_snapshot_agent_properties([@active_end_date] int, [@active_end_time_of_day] int,
                                                           [@active_start_date] int, [@active_start_time_of_day] int,
                                                           [@frequency_interval] int,
                                                           [@frequency_recurrence_factor] int,
                                                           [@frequency_relative_interval] int, [@frequency_subday] int,
                                                           [@frequency_subday_interval] int, [@frequency_type] int,
                                                           [@job_login] nvarchar(257), [@job_password] sysname,
                                                           [@publication] sysname, [@publisher] sysname,
                                                           [@publisher_db] sysname, [@publisher_login] sysname,
                                                           [@publisher_password] nvarchar(524),
                                                           [@publisher_security_mode] int, [@publisher_type] sysname,
                                                           [@snapshot_job_name] nvarchar(100)) as -- missing source code
go

create procedure sys.sp_MSchange_subscription_dts_info([@change_password] bit, [@dts_package_location] int,
                                                       [@dts_package_name] sysname,
                                                       [@dts_package_password] nvarchar(524),
                                                       [@job_id] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSchangearticleresolver([@article_resolver] nvarchar(255), [@artid] uniqueidentifier,
                                                [@resolver_clsid] nvarchar(40),
                                                [@resolver_info] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MSchangedynamicsnapshotjobatdistributor([@active_end_date] int, [@active_end_time_of_day] int,
                                                                [@active_start_date] int,
                                                                [@active_start_time_of_day] int,
                                                                [@dynamic_filter_hostname] sysname,
                                                                [@dynamic_filter_login] sysname,
                                                                [@frequency_interval] int,
                                                                [@frequency_recurrence_factor] int,
                                                                [@frequency_relative_interval] int,
                                                                [@frequency_subday] int,
                                                                [@frequency_subday_interval] int, [@frequency_type] int,
                                                                [@job_login] nvarchar(257), [@job_password] sysname,
                                                                [@publication] sysname, [@publisher] sysname,
                                                                [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSchangedynsnaplocationatdistributor([@dynamic_filter_hostname] sysname,
                                                             [@dynamic_filter_login] sysname,
                                                             [@dynamic_snapshot_location] nvarchar(255),
                                                             [@publication] sysname, [@publisher] sysname,
                                                             [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSchangeobjectowner([@dest_owner] sysname, [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MScheckIsPubOfSub([@pubOfSub] bit, [@pubid] uniqueidentifier, [@subid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScheck_Jet_Subscriber([@Jet_datasource_path] sysname, [@is_jet] int, [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_MScheck_agent_instance([@agent_type] int, [@application_name] sysname) as -- missing source code
go

create procedure sys.sp_MScheck_dropobject([@objid] int) as -- missing source code
go

create procedure sys.sp_MScheck_logicalrecord_metadatamatch([@logical_record_lineage] varbinary(311),
                                                            [@metadata_type] tinyint, [@parent_nickname] int,
                                                            [@parent_rowguid] uniqueidentifier,
                                                            [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScheck_merge_subscription_count([@about_to_insert_new_subscription] bit, [@publisher] sysname,
                                                         [@publisher_engine_edition] int) as -- missing source code
go

create procedure sys.sp_MScheck_pub_identity([@current_max] bigint, [@max_identity] bigint, [@next_seed] bigint,
                                             [@pub_range] bigint, [@publisher] sysname, [@publisher_db] sysname,
                                             [@range] bigint, [@tablename] sysname,
                                             [@threshold] int) as -- missing source code
go

create procedure sys.sp_MScheck_pull_access([@agent_id] int, [@agent_type] int, [@publication_id] int,
                                            [@raise_fatal_error] bit) as -- missing source code
go

create procedure sys.sp_MScheck_snapshot_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                               [@valid_agent_exists] bit) as -- missing source code
go

create procedure sys.sp_MScheck_subscription([@pub_type] int, [@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_MScheck_subscription_expiry([@expired] bit, [@pubid] uniqueidentifier, [@subscriber] sysname,
                                                    [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MScheck_subscription_partition([@force_delete_other] bit, [@pubid] uniqueidentifier,
                                                       [@subid] uniqueidentifier, [@subscriber] sysname,
                                                       [@subscriber_db] sysname, [@subscriber_deleted] sysname,
                                                       [@subscriberdb_deleted] sysname,
                                                       [@valid] bit) as -- missing source code
go

create procedure sys.sp_MScheck_tran_retention([@agent_id] int, [@xact_seqno] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MScheckexistsgeneration([@gen] bigint, [@genguid] uniqueidentifier, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScheckexistsrecguid([@exists] bit, [@recguid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScheckfailedprevioussync([@last_sync_failed] bit, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScheckidentityrange([@artname] sysname, [@checkonly] int, [@next_seed] bigint,
                                             [@pubid] uniqueidentifier, [@range] bigint,
                                             [@threshold] int) as -- missing source code
go

create procedure sys.sp_MSchecksharedagentforpublication([@publication] sysname, [@publisher_db] sysname, [@publisher_id] int) as -- missing source code
go

create procedure sys.sp_MSchecksnapshotstatus([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MScleanup_agent_entry() as -- missing source code
go

create procedure sys.sp_MScleanup_conflict([@conflict_retention] int, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScleanup_publication_ADinfo([@database] sysname, [@name] sysname) as -- missing source code
go

create procedure sys.sp_MScleanup_subscription_distside_entry([@publication] sysname, [@publisher] sysname,
                                                              [@publisher_db] sysname, [@subscriber] sysname,
                                                              [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MScleanupdynamicsnapshotfolder([@dynamic_filter_hostname] sysname,
                                                       [@dynamic_filter_login] sysname,
                                                       [@dynamic_snapshot_location] nvarchar(260), [@partition_id] int,
                                                       [@publication] sysname, [@publisher] sysname,
                                                       [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MScleanupdynsnapshotvws() as -- missing source code
go

create procedure sys.sp_MScleanupmergepublisher_internal() as -- missing source code
go

create procedure sys.sp_MSclear_dynamic_snapshot_location([@deletefolder] bit, [@partition_id] int, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSclearresetpartialsnapshotprogressbit([@agent_id] int) as -- missing source code
go

create procedure sys.sp_MScomputelastsentgen([@repid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScomputemergearticlescreationorder([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MScomputemergeunresolvedrefs([@article] sysname, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSconflicttableexists([@artid] uniqueidentifier, [@exists] int, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScreate_all_article_repl_views([@snapshot_application_finished] bit) as -- missing source code
go

create procedure sys.sp_MScreate_article_repl_views([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MScreate_dist_tables() as -- missing source code
go

create procedure sys.sp_MScreate_logical_record_views([@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScreate_sub_tables([@p2p_table] bit, [@property_table] bit, [@sqlqueue_table] bit,
                                            [@subscription_articles_table] bit,
                                            [@tran_sub_table] bit) as -- missing source code
go

create procedure sys.sp_MScreate_tempgenhistorytable([@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScreatedisabledmltrigger([@source_object] sysname, [@source_owner] sysname) as -- missing source code
go

create procedure sys.sp_MScreatedummygeneration([@maxgen_whenadded] bigint, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScreateglobalreplica([@compatlevel] int, [@datasource_path] nvarchar(255),
                                              [@datasource_type] int, [@distributor] sysname, [@pubid] uniqueidentifier,
                                              [@publication] sysname, [@replica_db] sysname, [@replica_priority] real,
                                              [@replica_server] sysname, [@replica_version] int,
                                              [@replicastate] uniqueidentifier, [@replnick] varbinary(6), [@status] int,
                                              [@subid] uniqueidentifier, [@subscriber_type] tinyint,
                                              [@subscription_type] int, [@sync_type] tinyint) as -- missing source code
go

create procedure sys.sp_MScreatelightweightinsertproc([@artid] uniqueidentifier, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScreatelightweightmultipurposeproc([@artid] uniqueidentifier, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScreatelightweightprocstriggersconstraints([@artid] uniqueidentifier, [@next_seed] bigint,
                                                                    [@pubid] uniqueidentifier, [@range] bigint,
                                                                    [@threshold] int) as -- missing source code
go

create procedure sys.sp_MScreatelightweightupdateproc([@artid] uniqueidentifier, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MScreatemergedynamicsnapshot([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MScreateretry() as -- missing source code
go

create procedure sys.sp_MSdbuseraccess([@mode] nvarchar(10), [@qual] nvarchar(128)) as -- missing source code
go

create procedure sys.sp_MSdbuserpriv([@mode] nvarchar(10)) as -- missing source code
go

create procedure sys.sp_MSdefer_check([@objname] sysname, [@objowner] sysname) as -- missing source code
go

create procedure sys.sp_MSdelete_tracer_history([@cutoff_date] datetime, [@num_records_removed] int,
                                                [@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                [@tracer_id] int) as -- missing source code
go

create procedure sys.sp_MSdeletefoldercontents([@folder] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_MSdeletemetadataactionrequest([@pubid] uniqueidentifier, [@rowguid1] uniqueidentifier,
                                                      [@rowguid10] uniqueidentifier, [@rowguid100] uniqueidentifier,
                                                      [@rowguid11] uniqueidentifier, [@rowguid12] uniqueidentifier,
                                                      [@rowguid13] uniqueidentifier, [@rowguid14] uniqueidentifier,
                                                      [@rowguid15] uniqueidentifier, [@rowguid16] uniqueidentifier,
                                                      [@rowguid17] uniqueidentifier, [@rowguid18] uniqueidentifier,
                                                      [@rowguid19] uniqueidentifier, [@rowguid2] uniqueidentifier,
                                                      [@rowguid20] uniqueidentifier, [@rowguid21] uniqueidentifier,
                                                      [@rowguid22] uniqueidentifier, [@rowguid23] uniqueidentifier,
                                                      [@rowguid24] uniqueidentifier, [@rowguid25] uniqueidentifier,
                                                      [@rowguid26] uniqueidentifier, [@rowguid27] uniqueidentifier,
                                                      [@rowguid28] uniqueidentifier, [@rowguid29] uniqueidentifier,
                                                      [@rowguid3] uniqueidentifier, [@rowguid30] uniqueidentifier,
                                                      [@rowguid31] uniqueidentifier, [@rowguid32] uniqueidentifier,
                                                      [@rowguid33] uniqueidentifier, [@rowguid34] uniqueidentifier,
                                                      [@rowguid35] uniqueidentifier, [@rowguid36] uniqueidentifier,
                                                      [@rowguid37] uniqueidentifier, [@rowguid38] uniqueidentifier,
                                                      [@rowguid39] uniqueidentifier, [@rowguid4] uniqueidentifier,
                                                      [@rowguid40] uniqueidentifier, [@rowguid41] uniqueidentifier,
                                                      [@rowguid42] uniqueidentifier, [@rowguid43] uniqueidentifier,
                                                      [@rowguid44] uniqueidentifier, [@rowguid45] uniqueidentifier,
                                                      [@rowguid46] uniqueidentifier, [@rowguid47] uniqueidentifier,
                                                      [@rowguid48] uniqueidentifier, [@rowguid49] uniqueidentifier,
                                                      [@rowguid5] uniqueidentifier, [@rowguid50] uniqueidentifier,
                                                      [@rowguid51] uniqueidentifier, [@rowguid52] uniqueidentifier,
                                                      [@rowguid53] uniqueidentifier, [@rowguid54] uniqueidentifier,
                                                      [@rowguid55] uniqueidentifier, [@rowguid56] uniqueidentifier,
                                                      [@rowguid57] uniqueidentifier, [@rowguid58] uniqueidentifier,
                                                      [@rowguid59] uniqueidentifier, [@rowguid6] uniqueidentifier,
                                                      [@rowguid60] uniqueidentifier, [@rowguid61] uniqueidentifier,
                                                      [@rowguid62] uniqueidentifier, [@rowguid63] uniqueidentifier,
                                                      [@rowguid64] uniqueidentifier, [@rowguid65] uniqueidentifier,
                                                      [@rowguid66] uniqueidentifier, [@rowguid67] uniqueidentifier,
                                                      [@rowguid68] uniqueidentifier, [@rowguid69] uniqueidentifier,
                                                      [@rowguid7] uniqueidentifier, [@rowguid70] uniqueidentifier,
                                                      [@rowguid71] uniqueidentifier, [@rowguid72] uniqueidentifier,
                                                      [@rowguid73] uniqueidentifier, [@rowguid74] uniqueidentifier,
                                                      [@rowguid75] uniqueidentifier, [@rowguid76] uniqueidentifier,
                                                      [@rowguid77] uniqueidentifier, [@rowguid78] uniqueidentifier,
                                                      [@rowguid79] uniqueidentifier, [@rowguid8] uniqueidentifier,
                                                      [@rowguid80] uniqueidentifier, [@rowguid81] uniqueidentifier,
                                                      [@rowguid82] uniqueidentifier, [@rowguid83] uniqueidentifier,
                                                      [@rowguid84] uniqueidentifier, [@rowguid85] uniqueidentifier,
                                                      [@rowguid86] uniqueidentifier, [@rowguid87] uniqueidentifier,
                                                      [@rowguid88] uniqueidentifier, [@rowguid89] uniqueidentifier,
                                                      [@rowguid9] uniqueidentifier, [@rowguid90] uniqueidentifier,
                                                      [@rowguid91] uniqueidentifier, [@rowguid92] uniqueidentifier,
                                                      [@rowguid93] uniqueidentifier, [@rowguid94] uniqueidentifier,
                                                      [@rowguid95] uniqueidentifier, [@rowguid96] uniqueidentifier,
                                                      [@rowguid97] uniqueidentifier, [@rowguid98] uniqueidentifier,
                                                      [@rowguid99] uniqueidentifier,
                                                      [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSdeletepeerconflictrow([@conflict_table] nvarchar(270), [@origin_datasource] nvarchar(255),
                                                [@originator_id] nvarchar(32), [@row_id] nvarchar(19),
                                                [@tran_id] nvarchar(40)) as -- missing source code
go

create procedure sys.sp_MSdeleteretry([@rowguid] uniqueidentifier, [@tablenick] int,
                                      [@temptable] nvarchar(386)) as -- missing source code
go

create procedure sys.sp_MSdeletetranconflictrow([@conflict_table] sysname, [@row_id] sysname, [@tran_id] sysname) as -- missing source code
go

create procedure sys.sp_MSdelgenzero() as -- missing source code
go

create procedure sys.sp_MSdelrow([@articleisupdateable] bit, [@check_permission] int, [@compatlevel] int,
                                 [@generation] bigint, [@lineage_new] varbinary(311), [@lineage_old] varbinary(311),
                                 [@metadata_type] tinyint, [@partition_id] int, [@pubid] uniqueidentifier,
                                 [@publication_number] smallint, [@rowguid] uniqueidentifier,
                                 [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSdelrowsbatch([@check_permission] int, [@generation1] bigint, [@generation10] bigint,
                                       [@generation100] bigint, [@generation11] bigint, [@generation12] bigint,
                                       [@generation13] bigint, [@generation14] bigint, [@generation15] bigint,
                                       [@generation16] bigint, [@generation17] bigint, [@generation18] bigint,
                                       [@generation19] bigint, [@generation2] bigint, [@generation20] bigint,
                                       [@generation21] bigint, [@generation22] bigint, [@generation23] bigint,
                                       [@generation24] bigint, [@generation25] bigint, [@generation26] bigint,
                                       [@generation27] bigint, [@generation28] bigint, [@generation29] bigint,
                                       [@generation3] bigint, [@generation30] bigint, [@generation31] bigint,
                                       [@generation32] bigint, [@generation33] bigint, [@generation34] bigint,
                                       [@generation35] bigint, [@generation36] bigint, [@generation37] bigint,
                                       [@generation38] bigint, [@generation39] bigint, [@generation4] bigint,
                                       [@generation40] bigint, [@generation41] bigint, [@generation42] bigint,
                                       [@generation43] bigint, [@generation44] bigint, [@generation45] bigint,
                                       [@generation46] bigint, [@generation47] bigint, [@generation48] bigint,
                                       [@generation49] bigint, [@generation5] bigint, [@generation50] bigint,
                                       [@generation51] bigint, [@generation52] bigint, [@generation53] bigint,
                                       [@generation54] bigint, [@generation55] bigint, [@generation56] bigint,
                                       [@generation57] bigint, [@generation58] bigint, [@generation59] bigint,
                                       [@generation6] bigint, [@generation60] bigint, [@generation61] bigint,
                                       [@generation62] bigint, [@generation63] bigint, [@generation64] bigint,
                                       [@generation65] bigint, [@generation66] bigint, [@generation67] bigint,
                                       [@generation68] bigint, [@generation69] bigint, [@generation7] bigint,
                                       [@generation70] bigint, [@generation71] bigint, [@generation72] bigint,
                                       [@generation73] bigint, [@generation74] bigint, [@generation75] bigint,
                                       [@generation76] bigint, [@generation77] bigint, [@generation78] bigint,
                                       [@generation79] bigint, [@generation8] bigint, [@generation80] bigint,
                                       [@generation81] bigint, [@generation82] bigint, [@generation83] bigint,
                                       [@generation84] bigint, [@generation85] bigint, [@generation86] bigint,
                                       [@generation87] bigint, [@generation88] bigint, [@generation89] bigint,
                                       [@generation9] bigint, [@generation90] bigint, [@generation91] bigint,
                                       [@generation92] bigint, [@generation93] bigint, [@generation94] bigint,
                                       [@generation95] bigint, [@generation96] bigint, [@generation97] bigint,
                                       [@generation98] bigint, [@generation99] bigint, [@lineage_new1] varbinary(311),
                                       [@lineage_new10] varbinary(311), [@lineage_new100] varbinary(311),
                                       [@lineage_new11] varbinary(311), [@lineage_new12] varbinary(311),
                                       [@lineage_new13] varbinary(311), [@lineage_new14] varbinary(311),
                                       [@lineage_new15] varbinary(311), [@lineage_new16] varbinary(311),
                                       [@lineage_new17] varbinary(311), [@lineage_new18] varbinary(311),
                                       [@lineage_new19] varbinary(311), [@lineage_new2] varbinary(311),
                                       [@lineage_new20] varbinary(311), [@lineage_new21] varbinary(311),
                                       [@lineage_new22] varbinary(311), [@lineage_new23] varbinary(311),
                                       [@lineage_new24] varbinary(311), [@lineage_new25] varbinary(311),
                                       [@lineage_new26] varbinary(311), [@lineage_new27] varbinary(311),
                                       [@lineage_new28] varbinary(311), [@lineage_new29] varbinary(311),
                                       [@lineage_new3] varbinary(311), [@lineage_new30] varbinary(311),
                                       [@lineage_new31] varbinary(311), [@lineage_new32] varbinary(311),
                                       [@lineage_new33] varbinary(311), [@lineage_new34] varbinary(311),
                                       [@lineage_new35] varbinary(311), [@lineage_new36] varbinary(311),
                                       [@lineage_new37] varbinary(311), [@lineage_new38] varbinary(311),
                                       [@lineage_new39] varbinary(311), [@lineage_new4] varbinary(311),
                                       [@lineage_new40] varbinary(311), [@lineage_new41] varbinary(311),
                                       [@lineage_new42] varbinary(311), [@lineage_new43] varbinary(311),
                                       [@lineage_new44] varbinary(311), [@lineage_new45] varbinary(311),
                                       [@lineage_new46] varbinary(311), [@lineage_new47] varbinary(311),
                                       [@lineage_new48] varbinary(311), [@lineage_new49] varbinary(311),
                                       [@lineage_new5] varbinary(311), [@lineage_new50] varbinary(311),
                                       [@lineage_new51] varbinary(311), [@lineage_new52] varbinary(311),
                                       [@lineage_new53] varbinary(311), [@lineage_new54] varbinary(311),
                                       [@lineage_new55] varbinary(311), [@lineage_new56] varbinary(311),
                                       [@lineage_new57] varbinary(311), [@lineage_new58] varbinary(311),
                                       [@lineage_new59] varbinary(311), [@lineage_new6] varbinary(311),
                                       [@lineage_new60] varbinary(311), [@lineage_new61] varbinary(311),
                                       [@lineage_new62] varbinary(311), [@lineage_new63] varbinary(311),
                                       [@lineage_new64] varbinary(311), [@lineage_new65] varbinary(311),
                                       [@lineage_new66] varbinary(311), [@lineage_new67] varbinary(311),
                                       [@lineage_new68] varbinary(311), [@lineage_new69] varbinary(311),
                                       [@lineage_new7] varbinary(311), [@lineage_new70] varbinary(311),
                                       [@lineage_new71] varbinary(311), [@lineage_new72] varbinary(311),
                                       [@lineage_new73] varbinary(311), [@lineage_new74] varbinary(311),
                                       [@lineage_new75] varbinary(311), [@lineage_new76] varbinary(311),
                                       [@lineage_new77] varbinary(311), [@lineage_new78] varbinary(311),
                                       [@lineage_new79] varbinary(311), [@lineage_new8] varbinary(311),
                                       [@lineage_new80] varbinary(311), [@lineage_new81] varbinary(311),
                                       [@lineage_new82] varbinary(311), [@lineage_new83] varbinary(311),
                                       [@lineage_new84] varbinary(311), [@lineage_new85] varbinary(311),
                                       [@lineage_new86] varbinary(311), [@lineage_new87] varbinary(311),
                                       [@lineage_new88] varbinary(311), [@lineage_new89] varbinary(311),
                                       [@lineage_new9] varbinary(311), [@lineage_new90] varbinary(311),
                                       [@lineage_new91] varbinary(311), [@lineage_new92] varbinary(311),
                                       [@lineage_new93] varbinary(311), [@lineage_new94] varbinary(311),
                                       [@lineage_new95] varbinary(311), [@lineage_new96] varbinary(311),
                                       [@lineage_new97] varbinary(311), [@lineage_new98] varbinary(311),
                                       [@lineage_new99] varbinary(311), [@lineage_old1] varbinary(311),
                                       [@lineage_old10] varbinary(311), [@lineage_old100] varbinary(311),
                                       [@lineage_old11] varbinary(311), [@lineage_old12] varbinary(311),
                                       [@lineage_old13] varbinary(311), [@lineage_old14] varbinary(311),
                                       [@lineage_old15] varbinary(311), [@lineage_old16] varbinary(311),
                                       [@lineage_old17] varbinary(311), [@lineage_old18] varbinary(311),
                                       [@lineage_old19] varbinary(311), [@lineage_old2] varbinary(311),
                                       [@lineage_old20] varbinary(311), [@lineage_old21] varbinary(311),
                                       [@lineage_old22] varbinary(311), [@lineage_old23] varbinary(311),
                                       [@lineage_old24] varbinary(311), [@lineage_old25] varbinary(311),
                                       [@lineage_old26] varbinary(311), [@lineage_old27] varbinary(311),
                                       [@lineage_old28] varbinary(311), [@lineage_old29] varbinary(311),
                                       [@lineage_old3] varbinary(311), [@lineage_old30] varbinary(311),
                                       [@lineage_old31] varbinary(311), [@lineage_old32] varbinary(311),
                                       [@lineage_old33] varbinary(311), [@lineage_old34] varbinary(311),
                                       [@lineage_old35] varbinary(311), [@lineage_old36] varbinary(311),
                                       [@lineage_old37] varbinary(311), [@lineage_old38] varbinary(311),
                                       [@lineage_old39] varbinary(311), [@lineage_old4] varbinary(311),
                                       [@lineage_old40] varbinary(311), [@lineage_old41] varbinary(311),
                                       [@lineage_old42] varbinary(311), [@lineage_old43] varbinary(311),
                                       [@lineage_old44] varbinary(311), [@lineage_old45] varbinary(311),
                                       [@lineage_old46] varbinary(311), [@lineage_old47] varbinary(311),
                                       [@lineage_old48] varbinary(311), [@lineage_old49] varbinary(311),
                                       [@lineage_old5] varbinary(311), [@lineage_old50] varbinary(311),
                                       [@lineage_old51] varbinary(311), [@lineage_old52] varbinary(311),
                                       [@lineage_old53] varbinary(311), [@lineage_old54] varbinary(311),
                                       [@lineage_old55] varbinary(311), [@lineage_old56] varbinary(311),
                                       [@lineage_old57] varbinary(311), [@lineage_old58] varbinary(311),
                                       [@lineage_old59] varbinary(311), [@lineage_old6] varbinary(311),
                                       [@lineage_old60] varbinary(311), [@lineage_old61] varbinary(311),
                                       [@lineage_old62] varbinary(311), [@lineage_old63] varbinary(311),
                                       [@lineage_old64] varbinary(311), [@lineage_old65] varbinary(311),
                                       [@lineage_old66] varbinary(311), [@lineage_old67] varbinary(311),
                                       [@lineage_old68] varbinary(311), [@lineage_old69] varbinary(311),
                                       [@lineage_old7] varbinary(311), [@lineage_old70] varbinary(311),
                                       [@lineage_old71] varbinary(311), [@lineage_old72] varbinary(311),
                                       [@lineage_old73] varbinary(311), [@lineage_old74] varbinary(311),
                                       [@lineage_old75] varbinary(311), [@lineage_old76] varbinary(311),
                                       [@lineage_old77] varbinary(311), [@lineage_old78] varbinary(311),
                                       [@lineage_old79] varbinary(311), [@lineage_old8] varbinary(311),
                                       [@lineage_old80] varbinary(311), [@lineage_old81] varbinary(311),
                                       [@lineage_old82] varbinary(311), [@lineage_old83] varbinary(311),
                                       [@lineage_old84] varbinary(311), [@lineage_old85] varbinary(311),
                                       [@lineage_old86] varbinary(311), [@lineage_old87] varbinary(311),
                                       [@lineage_old88] varbinary(311), [@lineage_old89] varbinary(311),
                                       [@lineage_old9] varbinary(311), [@lineage_old90] varbinary(311),
                                       [@lineage_old91] varbinary(311), [@lineage_old92] varbinary(311),
                                       [@lineage_old93] varbinary(311), [@lineage_old94] varbinary(311),
                                       [@lineage_old95] varbinary(311), [@lineage_old96] varbinary(311),
                                       [@lineage_old97] varbinary(311), [@lineage_old98] varbinary(311),
                                       [@lineage_old99] varbinary(311), [@metadata_type1] tinyint,
                                       [@metadata_type10] tinyint, [@metadata_type100] tinyint,
                                       [@metadata_type11] tinyint, [@metadata_type12] tinyint,
                                       [@metadata_type13] tinyint, [@metadata_type14] tinyint,
                                       [@metadata_type15] tinyint, [@metadata_type16] tinyint,
                                       [@metadata_type17] tinyint, [@metadata_type18] tinyint,
                                       [@metadata_type19] tinyint, [@metadata_type2] tinyint,
                                       [@metadata_type20] tinyint, [@metadata_type21] tinyint,
                                       [@metadata_type22] tinyint, [@metadata_type23] tinyint,
                                       [@metadata_type24] tinyint, [@metadata_type25] tinyint,
                                       [@metadata_type26] tinyint, [@metadata_type27] tinyint,
                                       [@metadata_type28] tinyint, [@metadata_type29] tinyint,
                                       [@metadata_type3] tinyint, [@metadata_type30] tinyint,
                                       [@metadata_type31] tinyint, [@metadata_type32] tinyint,
                                       [@metadata_type33] tinyint, [@metadata_type34] tinyint,
                                       [@metadata_type35] tinyint, [@metadata_type36] tinyint,
                                       [@metadata_type37] tinyint, [@metadata_type38] tinyint,
                                       [@metadata_type39] tinyint, [@metadata_type4] tinyint,
                                       [@metadata_type40] tinyint, [@metadata_type41] tinyint,
                                       [@metadata_type42] tinyint, [@metadata_type43] tinyint,
                                       [@metadata_type44] tinyint, [@metadata_type45] tinyint,
                                       [@metadata_type46] tinyint, [@metadata_type47] tinyint,
                                       [@metadata_type48] tinyint, [@metadata_type49] tinyint,
                                       [@metadata_type5] tinyint, [@metadata_type50] tinyint,
                                       [@metadata_type51] tinyint, [@metadata_type52] tinyint,
                                       [@metadata_type53] tinyint, [@metadata_type54] tinyint,
                                       [@metadata_type55] tinyint, [@metadata_type56] tinyint,
                                       [@metadata_type57] tinyint, [@metadata_type58] tinyint,
                                       [@metadata_type59] tinyint, [@metadata_type6] tinyint,
                                       [@metadata_type60] tinyint, [@metadata_type61] tinyint,
                                       [@metadata_type62] tinyint, [@metadata_type63] tinyint,
                                       [@metadata_type64] tinyint, [@metadata_type65] tinyint,
                                       [@metadata_type66] tinyint, [@metadata_type67] tinyint,
                                       [@metadata_type68] tinyint, [@metadata_type69] tinyint,
                                       [@metadata_type7] tinyint, [@metadata_type70] tinyint,
                                       [@metadata_type71] tinyint, [@metadata_type72] tinyint,
                                       [@metadata_type73] tinyint, [@metadata_type74] tinyint,
                                       [@metadata_type75] tinyint, [@metadata_type76] tinyint,
                                       [@metadata_type77] tinyint, [@metadata_type78] tinyint,
                                       [@metadata_type79] tinyint, [@metadata_type8] tinyint,
                                       [@metadata_type80] tinyint, [@metadata_type81] tinyint,
                                       [@metadata_type82] tinyint, [@metadata_type83] tinyint,
                                       [@metadata_type84] tinyint, [@metadata_type85] tinyint,
                                       [@metadata_type86] tinyint, [@metadata_type87] tinyint,
                                       [@metadata_type88] tinyint, [@metadata_type89] tinyint,
                                       [@metadata_type9] tinyint, [@metadata_type90] tinyint,
                                       [@metadata_type91] tinyint, [@metadata_type92] tinyint,
                                       [@metadata_type93] tinyint, [@metadata_type94] tinyint,
                                       [@metadata_type95] tinyint, [@metadata_type96] tinyint,
                                       [@metadata_type97] tinyint, [@metadata_type98] tinyint,
                                       [@metadata_type99] tinyint, [@partition_id] int, [@pubid] uniqueidentifier,
                                       [@rowguid1] uniqueidentifier, [@rowguid10] uniqueidentifier,
                                       [@rowguid100] uniqueidentifier, [@rowguid11] uniqueidentifier,
                                       [@rowguid12] uniqueidentifier, [@rowguid13] uniqueidentifier,
                                       [@rowguid14] uniqueidentifier, [@rowguid15] uniqueidentifier,
                                       [@rowguid16] uniqueidentifier, [@rowguid17] uniqueidentifier,
                                       [@rowguid18] uniqueidentifier, [@rowguid19] uniqueidentifier,
                                       [@rowguid2] uniqueidentifier, [@rowguid20] uniqueidentifier,
                                       [@rowguid21] uniqueidentifier, [@rowguid22] uniqueidentifier,
                                       [@rowguid23] uniqueidentifier, [@rowguid24] uniqueidentifier,
                                       [@rowguid25] uniqueidentifier, [@rowguid26] uniqueidentifier,
                                       [@rowguid27] uniqueidentifier, [@rowguid28] uniqueidentifier,
                                       [@rowguid29] uniqueidentifier, [@rowguid3] uniqueidentifier,
                                       [@rowguid30] uniqueidentifier, [@rowguid31] uniqueidentifier,
                                       [@rowguid32] uniqueidentifier, [@rowguid33] uniqueidentifier,
                                       [@rowguid34] uniqueidentifier, [@rowguid35] uniqueidentifier,
                                       [@rowguid36] uniqueidentifier, [@rowguid37] uniqueidentifier,
                                       [@rowguid38] uniqueidentifier, [@rowguid39] uniqueidentifier,
                                       [@rowguid4] uniqueidentifier, [@rowguid40] uniqueidentifier,
                                       [@rowguid41] uniqueidentifier, [@rowguid42] uniqueidentifier,
                                       [@rowguid43] uniqueidentifier, [@rowguid44] uniqueidentifier,
                                       [@rowguid45] uniqueidentifier, [@rowguid46] uniqueidentifier,
                                       [@rowguid47] uniqueidentifier, [@rowguid48] uniqueidentifier,
                                       [@rowguid49] uniqueidentifier, [@rowguid5] uniqueidentifier,
                                       [@rowguid50] uniqueidentifier, [@rowguid51] uniqueidentifier,
                                       [@rowguid52] uniqueidentifier, [@rowguid53] uniqueidentifier,
                                       [@rowguid54] uniqueidentifier, [@rowguid55] uniqueidentifier,
                                       [@rowguid56] uniqueidentifier, [@rowguid57] uniqueidentifier,
                                       [@rowguid58] uniqueidentifier, [@rowguid59] uniqueidentifier,
                                       [@rowguid6] uniqueidentifier, [@rowguid60] uniqueidentifier,
                                       [@rowguid61] uniqueidentifier, [@rowguid62] uniqueidentifier,
                                       [@rowguid63] uniqueidentifier, [@rowguid64] uniqueidentifier,
                                       [@rowguid65] uniqueidentifier, [@rowguid66] uniqueidentifier,
                                       [@rowguid67] uniqueidentifier, [@rowguid68] uniqueidentifier,
                                       [@rowguid69] uniqueidentifier, [@rowguid7] uniqueidentifier,
                                       [@rowguid70] uniqueidentifier, [@rowguid71] uniqueidentifier,
                                       [@rowguid72] uniqueidentifier, [@rowguid73] uniqueidentifier,
                                       [@rowguid74] uniqueidentifier, [@rowguid75] uniqueidentifier,
                                       [@rowguid76] uniqueidentifier, [@rowguid77] uniqueidentifier,
                                       [@rowguid78] uniqueidentifier, [@rowguid79] uniqueidentifier,
                                       [@rowguid8] uniqueidentifier, [@rowguid80] uniqueidentifier,
                                       [@rowguid81] uniqueidentifier, [@rowguid82] uniqueidentifier,
                                       [@rowguid83] uniqueidentifier, [@rowguid84] uniqueidentifier,
                                       [@rowguid85] uniqueidentifier, [@rowguid86] uniqueidentifier,
                                       [@rowguid87] uniqueidentifier, [@rowguid88] uniqueidentifier,
                                       [@rowguid89] uniqueidentifier, [@rowguid9] uniqueidentifier,
                                       [@rowguid90] uniqueidentifier, [@rowguid91] uniqueidentifier,
                                       [@rowguid92] uniqueidentifier, [@rowguid93] uniqueidentifier,
                                       [@rowguid94] uniqueidentifier, [@rowguid95] uniqueidentifier,
                                       [@rowguid96] uniqueidentifier, [@rowguid97] uniqueidentifier,
                                       [@rowguid98] uniqueidentifier, [@rowguid99] uniqueidentifier,
                                       [@rows_tobe_deleted] int, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSdelrowsbatch_downloadonly([@check_permission] int, [@pubid] uniqueidentifier,
                                                    [@rowguid1] uniqueidentifier, [@rowguid10] uniqueidentifier,
                                                    [@rowguid100] uniqueidentifier, [@rowguid11] uniqueidentifier,
                                                    [@rowguid12] uniqueidentifier, [@rowguid13] uniqueidentifier,
                                                    [@rowguid14] uniqueidentifier, [@rowguid15] uniqueidentifier,
                                                    [@rowguid16] uniqueidentifier, [@rowguid17] uniqueidentifier,
                                                    [@rowguid18] uniqueidentifier, [@rowguid19] uniqueidentifier,
                                                    [@rowguid2] uniqueidentifier, [@rowguid20] uniqueidentifier,
                                                    [@rowguid21] uniqueidentifier, [@rowguid22] uniqueidentifier,
                                                    [@rowguid23] uniqueidentifier, [@rowguid24] uniqueidentifier,
                                                    [@rowguid25] uniqueidentifier, [@rowguid26] uniqueidentifier,
                                                    [@rowguid27] uniqueidentifier, [@rowguid28] uniqueidentifier,
                                                    [@rowguid29] uniqueidentifier, [@rowguid3] uniqueidentifier,
                                                    [@rowguid30] uniqueidentifier, [@rowguid31] uniqueidentifier,
                                                    [@rowguid32] uniqueidentifier, [@rowguid33] uniqueidentifier,
                                                    [@rowguid34] uniqueidentifier, [@rowguid35] uniqueidentifier,
                                                    [@rowguid36] uniqueidentifier, [@rowguid37] uniqueidentifier,
                                                    [@rowguid38] uniqueidentifier, [@rowguid39] uniqueidentifier,
                                                    [@rowguid4] uniqueidentifier, [@rowguid40] uniqueidentifier,
                                                    [@rowguid41] uniqueidentifier, [@rowguid42] uniqueidentifier,
                                                    [@rowguid43] uniqueidentifier, [@rowguid44] uniqueidentifier,
                                                    [@rowguid45] uniqueidentifier, [@rowguid46] uniqueidentifier,
                                                    [@rowguid47] uniqueidentifier, [@rowguid48] uniqueidentifier,
                                                    [@rowguid49] uniqueidentifier, [@rowguid5] uniqueidentifier,
                                                    [@rowguid50] uniqueidentifier, [@rowguid51] uniqueidentifier,
                                                    [@rowguid52] uniqueidentifier, [@rowguid53] uniqueidentifier,
                                                    [@rowguid54] uniqueidentifier, [@rowguid55] uniqueidentifier,
                                                    [@rowguid56] uniqueidentifier, [@rowguid57] uniqueidentifier,
                                                    [@rowguid58] uniqueidentifier, [@rowguid59] uniqueidentifier,
                                                    [@rowguid6] uniqueidentifier, [@rowguid60] uniqueidentifier,
                                                    [@rowguid61] uniqueidentifier, [@rowguid62] uniqueidentifier,
                                                    [@rowguid63] uniqueidentifier, [@rowguid64] uniqueidentifier,
                                                    [@rowguid65] uniqueidentifier, [@rowguid66] uniqueidentifier,
                                                    [@rowguid67] uniqueidentifier, [@rowguid68] uniqueidentifier,
                                                    [@rowguid69] uniqueidentifier, [@rowguid7] uniqueidentifier,
                                                    [@rowguid70] uniqueidentifier, [@rowguid71] uniqueidentifier,
                                                    [@rowguid72] uniqueidentifier, [@rowguid73] uniqueidentifier,
                                                    [@rowguid74] uniqueidentifier, [@rowguid75] uniqueidentifier,
                                                    [@rowguid76] uniqueidentifier, [@rowguid77] uniqueidentifier,
                                                    [@rowguid78] uniqueidentifier, [@rowguid79] uniqueidentifier,
                                                    [@rowguid8] uniqueidentifier, [@rowguid80] uniqueidentifier,
                                                    [@rowguid81] uniqueidentifier, [@rowguid82] uniqueidentifier,
                                                    [@rowguid83] uniqueidentifier, [@rowguid84] uniqueidentifier,
                                                    [@rowguid85] uniqueidentifier, [@rowguid86] uniqueidentifier,
                                                    [@rowguid87] uniqueidentifier, [@rowguid88] uniqueidentifier,
                                                    [@rowguid89] uniqueidentifier, [@rowguid9] uniqueidentifier,
                                                    [@rowguid90] uniqueidentifier, [@rowguid91] uniqueidentifier,
                                                    [@rowguid92] uniqueidentifier, [@rowguid93] uniqueidentifier,
                                                    [@rowguid94] uniqueidentifier, [@rowguid95] uniqueidentifier,
                                                    [@rowguid96] uniqueidentifier, [@rowguid97] uniqueidentifier,
                                                    [@rowguid98] uniqueidentifier, [@rowguid99] uniqueidentifier,
                                                    [@rows_tobe_deleted] int,
                                                    [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSdelsubrows([@allarticlesareupdateable] bit, [@compatlevel] int, [@generation] bigint,
                                     [@lineage_new] varbinary(311), [@lineage_old] varbinary(311),
                                     [@metadata_type] tinyint, [@pubid] uniqueidentifier, [@rowguid] uniqueidentifier,
                                     [@rowsdeleted] int, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSdelsubrowsbatch([@allarticlesareupdateable] bit, [@generation_array] varbinary(4000),
                                          [@metadatatype_array] varbinary(500), [@newlineage_array] varbinary(311),
                                          [@newlineage_len_array] varbinary(1000), [@oldlineage_array] varbinary(311),
                                          [@oldlineage_len_array] varbinary(1000), [@pubid] uniqueidentifier,
                                          [@rowguid_array] varbinary(8000), [@rowsdeleted] int,
                                          [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSdependencies([@flags] int, [@intrans] int, [@objlist] nvarchar(128), [@objname] nvarchar(517),
                                       [@objtype] int) as -- missing source code
go

create procedure sys.sp_MSdetect_nonlogged_shutdown([@agent_id] int, [@subsystem] nvarchar(60)) as -- missing source code
go

create procedure sys.sp_MSdetectinvalidpeerconfiguration([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSdetectinvalidpeersubscription([@article] sysname, [@dest_owner] sysname,
                                                        [@dest_table] sysname, [@publication] sysname,
                                                        [@publisher] sysname, [@publisher_db] sysname,
                                                        [@type] sysname) as -- missing source code
go

create procedure sys.sp_MSdist_activate_auto_sub([@article_id] int, [@publisher_db] sysname, [@publisher_id] int) as -- missing source code
go

create procedure sys.sp_MSdist_adjust_identity([@agent_id] int, [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSdistpublisher_cleanup([@publisher] sysname) as -- missing source code
go

create procedure sys.sp_MSdistribution_counters([@publisher] sysname) as -- missing source code
go

create procedure sys.sp_MSdistributoravailable() as -- missing source code
go

create procedure sys.sp_MSdodatabasesnapshotinitiation([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSdopartialdatabasesnapshotinitiation([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSdrop_6x_publication([@job_id] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSdrop_6x_replication_agent([@category_id] int, [@job_id] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSdrop_anonymous_entry([@login] sysname, [@subid] uniqueidentifier, [@type] int) as -- missing source code
go

create procedure sys.sp_MSdrop_article([@article] sysname, [@publication] sysname, [@publisher] sysname,
                                       [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSdrop_distribution_agent([@job_only] bit, [@keep_for_last_run] bit, [@publication] sysname,
                                                  [@publisher_db] sysname, [@publisher_id] smallint,
                                                  [@subscriber_db] sysname, [@subscriber_id] smallint,
                                                  [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MSdrop_distribution_agentid_dbowner_proxy([@agent_id] int) as -- missing source code
go

create procedure sys.sp_MSdrop_dynamic_snapshot_agent([@agent_id] int, [@publication] sysname, [@publisher] sysname,
                                                      [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSdrop_logreader_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSdrop_merge_agent([@job_only] bit, [@keep_for_last_run] bit, [@publication] sysname,
                                           [@publisher] sysname, [@publisher_db] sysname, [@subscriber] sysname,
                                           [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSdrop_merge_subscription([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                  [@subscriber] sysname, [@subscriber_db] sysname,
                                                  [@subscription_type] nvarchar(15)) as -- missing source code
go

create procedure sys.sp_MSdrop_publication([@alt_snapshot_folder] sysname, [@cleanup_orphans] bit,
                                           [@publication] sysname, [@publisher] sysname,
                                           [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSdrop_qreader_history([@publication_id] int) as -- missing source code
go

create procedure sys.sp_MSdrop_snapshot_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSdrop_snapshot_dirs() as -- missing source code
go

create procedure sys.sp_MSdrop_subscriber_info([@publisher] sysname, [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_MSdrop_subscription([@article] sysname, [@article_id] int, [@publication] sysname,
                                            [@publisher] sysname, [@publisher_db] sysname, [@subscriber] sysname,
                                            [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSdrop_subscription_3rd([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                [@subscriber] sysname,
                                                [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSdrop_tempgenhistorytable([@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSdroparticleconstraints([@destination_object] sysname, [@destination_owner] sysname) as -- missing source code
go

create procedure sys.sp_MSdroparticletombstones([@artid] uniqueidentifier, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSdropconstraints([@owner] sysname, [@table] sysname) as -- missing source code
go

create procedure sys.sp_MSdropdynsnapshotvws([@dynamic_snapshot_views_table] sysname) as -- missing source code
go

create procedure sys.sp_MSdropfkreferencingarticle([@destination_object_name] sysname, [@destination_owner_name] sysname) as -- missing source code
go

create procedure sys.sp_MSdropmergearticle([@artid] uniqueidentifier, [@ignore_merge_metadata] bit,
                                           [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSdropmergedynamicsnapshotjob([@dynamic_snapshot_jobid] uniqueidentifier,
                                                      [@dynamic_snapshot_jobname] sysname, [@ignore_distributor] bit,
                                                      [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSdropobsoletearticle([@artid] int, [@force_invalidate_snapshot] bit,
                                              [@ignore_distributor] bit) as -- missing source code
go

create procedure sys.sp_MSdropretry([@pname] sysname, [@tname] sysname) as -- missing source code
go

create procedure sys.sp_MSdroptemptable([@tname] sysname) as -- missing source code
go

create procedure sys.sp_MSdummyupdate([@incolv] varbinary(2953), [@inlineage] varbinary(311), [@metatype] tinyint,
                                      [@pubid] uniqueidentifier, [@rowguid] uniqueidentifier, [@tablenick] int,
                                      [@uplineage] tinyint) as -- missing source code
go

create procedure sys.sp_MSdummyupdate90([@incolv] varbinary(2953), [@inlineage] varbinary(311),
                                        [@logical_record_parent_rowguid] uniqueidentifier, [@metatype] tinyint,
                                        [@pubid] uniqueidentifier, [@rowguid] uniqueidentifier,
                                        [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSdummyupdate_logicalrecord([@dest_common_gen] bigint, [@parent_nickname] int,
                                                    [@parent_rowguid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSdummyupdatelightweight([@action] int, [@metatype] tinyint, [@rowguid] uniqueidentifier,
                                                 [@rowvector] varbinary(11), [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSdynamicsnapshotjobexistsatdistributor([@dynamic_filter_hostname] sysname,
                                                                [@dynamic_filter_login] sysname,
                                                                [@dynamic_snapshot_jobid] uniqueidentifier,
                                                                [@publication] sysname, [@publisher] sysname,
                                                                [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSenable_publication_for_het_sub([@publication] sysname, [@publisher] sysname,
                                                         [@publisher_db] sysname,
                                                         [@sync_method] int) as -- missing source code
go

create procedure sys.sp_MSensure_single_instance([@agent_type] int, [@application_name] sysname) as -- missing source code
go

create procedure sys.sp_MSenum_distribution([@exclude_anonymous] bit, [@name] nvarchar(100), [@show_distdb] bit) as -- missing source code
go

create procedure sys.sp_MSenum_distribution_s([@hours] int, [@name] nvarchar(100), [@session_type] int) as -- missing source code
go

create procedure sys.sp_MSenum_distribution_sd([@name] nvarchar(100), [@time] datetime) as -- missing source code
go

create procedure sys.sp_MSenum_logicalrecord_changes([@enumentirerowmetadata] bit, [@genlist] varchar(8000),
                                                     [@maxgen] bigint, [@maxschemaguidforarticle] uniqueidentifier,
                                                     [@mingen] bigint, [@oldmaxgen] bigint, [@parent_nickname] int,
                                                     [@partition_id] int,
                                                     [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSenum_logreader([@name] nvarchar(100), [@show_distdb] bit) as -- missing source code
go

create procedure sys.sp_MSenum_logreader_s([@hours] int, [@name] nvarchar(100), [@session_type] int) as -- missing source code
go

create procedure sys.sp_MSenum_logreader_sd([@name] nvarchar(100), [@time] datetime) as -- missing source code
go

create procedure sys.sp_MSenum_merge([@exclude_anonymous] bit, [@name] nvarchar(100), [@show_distdb] bit) as -- missing source code
go

create procedure sys.sp_MSenum_merge_agent_properties([@publication] sysname, [@publisher] sysname,
                                                      [@publisher_db] sysname,
                                                      [@show_security] bit) as -- missing source code
go

create procedure sys.sp_MSenum_merge_s([@hours] int, [@name] nvarchar(100), [@session_type] int) as -- missing source code
go

create procedure sys.sp_MSenum_merge_sd([@name] nvarchar(100), [@time] datetime) as -- missing source code
go

create procedure sys.sp_MSenum_merge_subscriptions([@exclude_anonymous] bit, [@publication] sysname,
                                                   [@publisher] sysname,
                                                   [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSenum_merge_subscriptions_90_publication([@exclude_anonymous] bit, [@publication] sysname,
                                                                  [@publisher] sysname, [@publisher_db] sysname,
                                                                  [@topNum] int) as -- missing source code
go

create procedure sys.sp_MSenum_merge_subscriptions_90_publisher([@exclude_anonymous] bit, [@publisher] sysname, [@topNum] int) as -- missing source code
go

create procedure sys.sp_MSenum_metadataaction_requests([@max_rows] int, [@pubid] uniqueidentifier,
                                                       [@rowguid_last] uniqueidentifier,
                                                       [@tablenick_last] int) as -- missing source code
go

create procedure sys.sp_MSenum_qreader([@name] nvarchar(100), [@show_distdb] bit) as -- missing source code
go

create procedure sys.sp_MSenum_qreader_s([@hours] int, [@publication_id] int, [@session_type] int) as -- missing source code
go

create procedure sys.sp_MSenum_qreader_sd([@publication_id] int, [@time] datetime) as -- missing source code
go

create procedure sys.sp_MSenum_replication_agents([@check_user] bit, [@exclude_anonymous] bit, [@type] int) as -- missing source code
go

create procedure sys.sp_MSenum_replication_job([@job_id] uniqueidentifier, [@step_uid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSenum_replqueues([@curdistdb] sysname) as -- missing source code
go

create procedure sys.sp_MSenum_replsqlqueues([@curdistdb] sysname) as -- missing source code
go

create procedure sys.sp_MSenum_snapshot([@name] nvarchar(100), [@show_distdb] bit) as -- missing source code
go

create procedure sys.sp_MSenum_snapshot_s([@hours] int, [@name] nvarchar(100), [@session_type] int) as -- missing source code
go

create procedure sys.sp_MSenum_snapshot_sd([@name] nvarchar(100), [@time] datetime) as -- missing source code
go

create procedure sys.sp_MSenum_subscriptions([@exclude_anonymous] bit, [@publication] sysname, [@publisher] sysname,
                                             [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSenumallpublications([@agent_login] sysname, [@empty_tranpub] bit, [@hrepl_pub] bit,
                                              [@publication] sysname, [@publisherdb] sysname,
                                              [@replication_type] tinyint, [@security_check] bit,
                                              [@vendor_name] sysname) as -- missing source code
go

create procedure sys.sp_MSenumallsubscriptions([@subscriber_db] sysname, [@subscription_type] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_MSenumarticleslightweight([@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSenumchanges([@blob_cols_at_the_end] bit, [@compatlevel] int, [@enumentirerowmetadata] bit,
                                      [@genlist] varchar(8000), [@maxgen] bigint, [@maxrows] int,
                                      [@maxschemaguidforarticle] uniqueidentifier, [@mingen] bigint,
                                      [@oldmaxgen] bigint, [@pubid] uniqueidentifier,
                                      [@return_count_of_rows_initially_enumerated] bit, [@rowguid] uniqueidentifier,
                                      [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSenumchanges_belongtopartition([@blob_cols_at_the_end] bit, [@enumentirerowmetadata] bit,
                                                        [@genlist] varchar(8000), [@maxgen] bigint, [@maxrows] int,
                                                        [@maxschemaguidforarticle] uniqueidentifier, [@mingen] bigint,
                                                        [@partition_id] int, [@pubid] uniqueidentifier,
                                                        [@rowguid] uniqueidentifier,
                                                        [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSenumchanges_notbelongtopartition([@enumentirerowmetadata] bit, [@genlist] varchar(8000),
                                                           [@maxgen] bigint, [@maxrows] int, [@mingen] bigint,
                                                           [@partition_id] int, [@pubid] uniqueidentifier,
                                                           [@rowguid] uniqueidentifier,
                                                           [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSenumchangesdirect([@blob_cols_at_the_end] bit, [@compatlevel] int,
                                            [@enumentirerowmetadata] bit, [@genlist] varchar(2000), [@maxgen] bigint,
                                            [@maxrows] int, [@maxschemaguidforarticle] uniqueidentifier,
                                            [@mingen] bigint, [@oldmaxgen] bigint, [@pubid] uniqueidentifier,
                                            [@rowguid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSenumchangeslightweight([@lastrowguid] uniqueidentifier, [@maxrows] int,
                                                 [@pubid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSenumcolumns([@artid] uniqueidentifier, [@maxschemaguidforarticle] uniqueidentifier,
                                      [@pubid] uniqueidentifier,
                                      [@show_filtering_columns] bit) as -- missing source code
go

create procedure sys.sp_MSenumcolumnslightweight([@artid] uniqueidentifier, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSenumdeletes_forpartition([@enumentirerowmetadata] bit, [@genlist] varchar(8000),
                                                   [@maxgen] bigint, [@maxrows] int, [@mingen] bigint,
                                                   [@partition_id] int, [@pubid] uniqueidentifier,
                                                   [@rowguid] uniqueidentifier,
                                                   [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSenumdeleteslightweight([@lastrowguid] uniqueidentifier, [@maxrows] int,
                                                 [@pubid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSenumdeletesmetadata([@compatlevel] int, [@enumentirerowmetadata] bit,
                                              [@filter_partialdeletes] int, [@genlist] varchar(8000), [@maxgen] bigint,
                                              [@maxrows] int, [@mingen] bigint, [@pubid] uniqueidentifier,
                                              [@rowguid] uniqueidentifier, [@specified_article_only] int,
                                              [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSenumdistributionagentproperties([@publication] sysname, [@publisher] sysname,
                                                          [@publisher_db] sysname,
                                                          [@show_security] bit) as -- missing source code
go

create procedure sys.sp_MSenumerate_PAL([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSenumgenerations([@genstart] bigint, [@pubid] uniqueidentifier,
                                          [@return_count_of_generations] bit) as -- missing source code
go

create procedure sys.sp_MSenumgenerations90([@genstart] bigint, [@maxgen_to_enumerate] bigint,
                                            [@mingen_to_enumerate] bigint, [@numgens] int, [@partition_id] int,
                                            [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSenumpartialchanges([@blob_cols_at_the_end] bit, [@compatlevel] int,
                                             [@enumentirerowmetadata] bit, [@maxrows] int,
                                             [@maxschemaguidforarticle] uniqueidentifier, [@pubid] uniqueidentifier,
                                             [@return_count_of_rows_initially_enumerated] bit,
                                             [@rowguid] uniqueidentifier, [@tablenick] int,
                                             [@temp_cont] sysname) as -- missing source code
go

create procedure sys.sp_MSenumpartialchangesdirect([@blob_cols_at_the_end] bit, [@compatlevel] int,
                                                   [@enumentirerowmetadata] bit, [@maxrows] int,
                                                   [@maxschemaguidforarticle] uniqueidentifier,
                                                   [@pubid] uniqueidentifier, [@rowguid] uniqueidentifier,
                                                   [@tablenick] int, [@temp_cont] sysname) as -- missing source code
go

create procedure sys.sp_MSenumpartialdeletes([@bookmark] int, [@compatlevel] int, [@enumentirerowmetadata] bit,
                                             [@maxrows] int, [@pubid] uniqueidentifier, [@rowguid] uniqueidentifier,
                                             [@specified_article_only] int, [@tablenick] int,
                                             [@tablenotbelongs] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_MSenumpubreferences([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSenumreplicas([@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSenumreplicas90() as -- missing source code
go

create procedure sys.sp_MSenumretries([@maxrows] int, [@pubid] uniqueidentifier, [@rowguid] uniqueidentifier,
                                      [@tablenick] int, [@tname] nvarchar(126)) as -- missing source code
go

create procedure sys.sp_MSenumschemachange([@AlterTableOnly] bit, [@compatlevel] int,
                                           [@filter_skipped_schemachanges] bit,
                                           [@invalidateupload_schemachanges_for_ssce] bit, [@pubid] uniqueidentifier,
                                           [@schemaversion] int) as -- missing source code
go

create procedure sys.sp_MSenumsubscriptions([@publisher] sysname, [@publisher_db] sysname, [@reserved] bit,
                                            [@subscription_type] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_MSenumthirdpartypublicationvendornames([@within_db] bit) as -- missing source code
go

create procedure sys.sp_MSestimatemergesnapshotworkload([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSestimatesnapshotworkload([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSevalsubscriberinfo([@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSevaluate_change_membership_for_all_articles_in_pubid([@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSevaluate_change_membership_for_pubid([@partition_id] int, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSevaluate_change_membership_for_row([@marker] uniqueidentifier, [@rowguid] uniqueidentifier,
                                                             [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSexecwithlsnoutput([@command] nvarchar(max), [@xact_seqno] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSfast_delete_trans() as -- missing source code
go

create procedure sys.sp_MSfetchAdjustidentityrange([@adjust_only] bit, [@for_publisher] tinyint, [@next_seed] bigint,
                                                   [@publisher] sysname, [@publisher_db] sysname, [@range] bigint,
                                                   [@tablename] sysname, [@threshold] int) as -- missing source code
go

create procedure sys.sp_MSfetchidentityrange([@adjust_only] bit, [@table_owner] sysname,
                                             [@tablename] nvarchar(270)) as -- missing source code
go

create procedure sys.sp_MSfillupmissingcols([@publication] sysname, [@source_table] sysname) as -- missing source code
go

create procedure sys.sp_MSfilterclause([@article] nvarchar(258), [@publication] nvarchar(258)) as -- missing source code
go

create procedure sys.sp_MSfix_6x_tasks([@publisher] sysname, [@publisher_engine_edition] int) as -- missing source code
go

create procedure sys.sp_MSfixlineageversions() as -- missing source code
go

create procedure sys.sp_MSfixupbeforeimagetables([@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSflush_access_cache() as -- missing source code
go

create procedure sys.sp_MSforce_drop_distribution_jobs([@publisher] sysname, [@publisher_db] sysname, [@type] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_MSforcereenumeration([@rowguid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSforeach_worker([@command1] nvarchar(2000), [@command2] nvarchar(2000),
                                         [@command3] nvarchar(2000), [@replacechar] nchar(1),
                                         [@worker_type] int) as -- missing source code
go

create procedure sys.sp_MSforeachdb([@command1] nvarchar(2000), [@command2] nvarchar(2000), [@command3] nvarchar(2000),
                                    [@postcommand] nvarchar(2000), [@precommand] nvarchar(2000),
                                    [@replacechar] nchar(1)) as -- missing source code
go

create procedure sys.sp_MSforeachtable([@command1] nvarchar(2000), [@command2] nvarchar(2000),
                                       [@command3] nvarchar(2000), [@postcommand] nvarchar(2000),
                                       [@precommand] nvarchar(2000), [@replacechar] nchar(1),
                                       [@whereand] nvarchar(2000)) as -- missing source code
go

create procedure sys.sp_MSgenerateexpandproc([@procname] sysname, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSget_DDL_after_regular_snapshot([@ddl_present] bit, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSget_MSmerge_rowtrack_colinfo() as -- missing source code
go

create procedure sys.sp_MSget_agent_names([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                          [@subscriber] sysname, [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSget_attach_state([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                           [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MSget_dynamic_snapshot_location([@dynsnap_location] nvarchar(255), [@partition_id] int,
                                                        [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSget_identity_range_info([@artid] uniqueidentifier, [@next_range_begin] numeric(38),
                                                  [@next_range_end] numeric(38), [@range_begin] numeric(38),
                                                  [@range_end] numeric(38), [@range_type] tinyint,
                                                  [@ranges_needed] tinyint,
                                                  [@subid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSget_jobstate([@job_id] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSget_last_transaction([@for_truncate] bit, [@max_xact_seqno] varbinary(16),
                                               [@publisher] sysname, [@publisher_db] sysname,
                                               [@publisher_id] int) as -- missing source code
go

create procedure sys.sp_MSget_latest_peerlsn([@originator] sysname, [@originator_db] sysname,
                                             [@originator_publication] sysname,
                                             [@xact_seqno] binary(10)) as -- missing source code
go

create procedure sys.sp_MSget_load_hint([@is_vertically_partitioned] bit, [@primary_key_only] bit,
                                        [@qualified_source_object_name] nvarchar(4000),
                                        [@qualified_sync_object_name] nvarchar(4000)) as -- missing source code
go

create procedure sys.sp_MSget_log_shipping_new_sessionid([@agent_id] uniqueidentifier, [@agent_type] tinyint,
                                                         [@session_id] int) as -- missing source code
go

create procedure sys.sp_MSget_logicalrecord_lineage([@dest_common_gen] bigint, [@parent_nickname] int,
                                                    [@parent_rowguid] uniqueidentifier,
                                                    [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSget_max_used_identity([@article] sysname, [@max_used] numeric(38), [@publication] sysname,
                                                [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSget_min_seqno([@agent_id] int, [@xact_seqno] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSget_new_xact_seqno([@len] tinyint, [@publisher_db] sysname, [@publisher_id] int) as -- missing source code
go

create procedure sys.sp_MSget_oledbinfo([@infotype] nvarchar(128), [@login] nvarchar(128), [@password] nvarchar(128),
                                        [@server] nvarchar(128)) as -- missing source code
go

create procedure sys.sp_MSget_partitionid_eval_proc([@column_list] nvarchar(2000), [@function_list] nvarchar(2000),
                                                    [@partition_id_eval_clause] nvarchar(2000),
                                                    [@partition_id_eval_proc] sysname, [@pubid] uniqueidentifier,
                                                    [@publication_number] smallint,
                                                    [@use_partition_groups] smallint) as -- missing source code
go

create procedure sys.sp_MSget_publication_from_taskname([@publication] sysname, [@publisher] sysname,
                                                        [@publisherdb] sysname,
                                                        [@taskname] sysname) as -- missing source code
go

create procedure sys.sp_MSget_publisher_rpc([@connect_string] nvarchar(2000), [@owner] sysname,
                                            [@trigger_id] int) as -- missing source code
go

create procedure sys.sp_MSget_repl_cmds_anonymous([@agent_id] int, [@compatibility_level] int, [@get_count] tinyint,
                                                  [@last_xact_seqno] varbinary(16),
                                                  [@no_init_sync] bit) as -- missing source code
go

create procedure sys.sp_MSget_repl_commands([@agent_id] int, [@compatibility_level] int, [@get_count] tinyint,
                                            [@last_xact_seqno] varbinary(16), [@read_query_size] int,
                                            [@subdb_version] int) as -- missing source code
go

create procedure sys.sp_MSget_repl_error([@id] int) as -- missing source code
go

create procedure sys.sp_MSget_session_statistics([@session_id] int) as -- missing source code
go

create procedure sys.sp_MSget_shared_agent([@agent_type] int, [@database_name] sysname, [@publisher] sysname,
                                           [@publisher_db] sysname, [@server_name] sysname) as -- missing source code
go

create procedure sys.sp_MSget_snapshot_history([@agent_id] int, [@rowcount] int, [@timestamp] timestamp) as -- missing source code
go

create procedure sys.sp_MSget_subscriber_partition_id([@host_name_override] sysname, [@maxgen_whenadded] bigint,
                                                      [@partition_id] int, [@publication] sysname,
                                                      [@suser_sname_override] sysname) as -- missing source code
go

create procedure sys.sp_MSget_subscription_dts_info([@job_id] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSget_subscription_guid([@agent_id] int) as -- missing source code
go

create procedure sys.sp_MSget_synctran_commands([@alter] bit, [@article] sysname, [@command_only] bit,
                                                [@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                [@trig_only] bit, [@usesqlclr] bit) as -- missing source code
go

create procedure sys.sp_MSget_type_wrapper([@colid] int, [@colname] sysname, [@tabid] int,
                                           [@typestring] nvarchar(4000)) as -- missing source code
go

create procedure sys.sp_MSgetagentoffloadinfo([@job_id] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSgetalertinfo([@includeaddresses] bit) as -- missing source code
go

create procedure sys.sp_MSgetalternaterecgens([@repid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSgetarticlereinitvalue([@artid] int, [@publication] sysname, [@reinit] int,
                                                [@subscriber] sysname,
                                                [@subscriberdb] sysname) as -- missing source code
go

create procedure sys.sp_MSgetchangecount([@changes] int, [@deletes] int, [@startgen] bigint, [@updates] int) as -- missing source code
go

create procedure sys.sp_MSgetconflictinsertproc([@artid] uniqueidentifier, [@force_generate_proc] bit, [@output] int,
                                                [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSgetconflicttablename([@conflict_table] sysname, [@publication] sysname,
                                               [@source_object] nvarchar(520)) as -- missing source code
go

create procedure sys.sp_MSgetdatametadatabatch([@all_articles_are_guaranteed_to_be_updateable_at_other_replica] bit,
                                               [@logical_record_parent_rowguid] uniqueidentifier,
                                               [@pubid] uniqueidentifier, [@rowguidarray] varbinary(8000),
                                               [@tablenickarray] varbinary(2000)) as -- missing source code
go

create procedure sys.sp_MSgetdbversion([@current_version] int) as -- missing source code
go

create procedure sys.sp_MSgetdynamicsnapshotapplock([@lock_acquired] int, [@partition_id] int, [@publication] sysname,
                                                    [@timeout] int) as -- missing source code
go

create procedure sys.sp_MSgetdynsnapvalidationtoken([@dynamic_filter_login] sysname, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSgetgenstatus4rows([@repid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSgetisvalidwindowsloginfromdistributor([@isvalid] bit, [@login] nvarchar(257), [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_MSgetlastrecgen([@repid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSgetlastsentgen([@repid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSgetlastsentrecgens([@repid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSgetlastupdatedtime([@publication] sysname, [@publication_type] int, [@publisher] sysname,
                                             [@publisher_db] sysname,
                                             [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MSgetlightweightmetadatabatch([@artnickarray] varbinary(2000), [@pubid] uniqueidentifier,
                                                      [@rowguidarray] varbinary(8000)) as -- missing source code
go

create procedure sys.sp_MSgetmakegenerationapplock([@head_of_queue] int) as -- missing source code
go

create procedure sys.sp_MSgetmakegenerationapplock_90([@lock_acquired] int, [@wait_time] int) as -- missing source code
go

create procedure sys.sp_MSgetmaxbcpgen([@max_closed_gen] bigint) as -- missing source code
go

create procedure sys.sp_MSgetmaxsnapshottimestamp([@agent_id] int, [@timestamp] timestamp) as -- missing source code
go

create procedure sys.sp_MSgetmergeadminapplock([@lock_acquired] int, [@lockmode] nvarchar(32),
                                               [@lockowner] nvarchar(32), [@timeout] int) as -- missing source code
go

create procedure sys.sp_MSgetmetadata_changedlogicalrecordmembers([@commongen] bigint, [@parent_nickname] int,
                                                                  [@parent_rowguid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSgetmetadatabatch([@compatlevel] int, [@lightweight] int, [@pubid] uniqueidentifier,
                                           [@rowguidarray] varbinary(8000),
                                           [@tablenickarray] varbinary(2000)) as -- missing source code
go

create procedure sys.sp_MSgetmetadatabatch90([@pubid] uniqueidentifier, [@rowguidarray] varbinary(8000),
                                             [@tablenickarray] varbinary(2000)) as -- missing source code
go

create procedure sys.sp_MSgetmetadatabatch90new([@pubid] uniqueidentifier, [@rowguid1] uniqueidentifier,
                                                [@rowguid10] uniqueidentifier, [@rowguid100] uniqueidentifier,
                                                [@rowguid11] uniqueidentifier, [@rowguid12] uniqueidentifier,
                                                [@rowguid13] uniqueidentifier, [@rowguid14] uniqueidentifier,
                                                [@rowguid15] uniqueidentifier, [@rowguid16] uniqueidentifier,
                                                [@rowguid17] uniqueidentifier, [@rowguid18] uniqueidentifier,
                                                [@rowguid19] uniqueidentifier, [@rowguid2] uniqueidentifier,
                                                [@rowguid20] uniqueidentifier, [@rowguid21] uniqueidentifier,
                                                [@rowguid22] uniqueidentifier, [@rowguid23] uniqueidentifier,
                                                [@rowguid24] uniqueidentifier, [@rowguid25] uniqueidentifier,
                                                [@rowguid26] uniqueidentifier, [@rowguid27] uniqueidentifier,
                                                [@rowguid28] uniqueidentifier, [@rowguid29] uniqueidentifier,
                                                [@rowguid3] uniqueidentifier, [@rowguid30] uniqueidentifier,
                                                [@rowguid31] uniqueidentifier, [@rowguid32] uniqueidentifier,
                                                [@rowguid33] uniqueidentifier, [@rowguid34] uniqueidentifier,
                                                [@rowguid35] uniqueidentifier, [@rowguid36] uniqueidentifier,
                                                [@rowguid37] uniqueidentifier, [@rowguid38] uniqueidentifier,
                                                [@rowguid39] uniqueidentifier, [@rowguid4] uniqueidentifier,
                                                [@rowguid40] uniqueidentifier, [@rowguid41] uniqueidentifier,
                                                [@rowguid42] uniqueidentifier, [@rowguid43] uniqueidentifier,
                                                [@rowguid44] uniqueidentifier, [@rowguid45] uniqueidentifier,
                                                [@rowguid46] uniqueidentifier, [@rowguid47] uniqueidentifier,
                                                [@rowguid48] uniqueidentifier, [@rowguid49] uniqueidentifier,
                                                [@rowguid5] uniqueidentifier, [@rowguid50] uniqueidentifier,
                                                [@rowguid51] uniqueidentifier, [@rowguid52] uniqueidentifier,
                                                [@rowguid53] uniqueidentifier, [@rowguid54] uniqueidentifier,
                                                [@rowguid55] uniqueidentifier, [@rowguid56] uniqueidentifier,
                                                [@rowguid57] uniqueidentifier, [@rowguid58] uniqueidentifier,
                                                [@rowguid59] uniqueidentifier, [@rowguid6] uniqueidentifier,
                                                [@rowguid60] uniqueidentifier, [@rowguid61] uniqueidentifier,
                                                [@rowguid62] uniqueidentifier, [@rowguid63] uniqueidentifier,
                                                [@rowguid64] uniqueidentifier, [@rowguid65] uniqueidentifier,
                                                [@rowguid66] uniqueidentifier, [@rowguid67] uniqueidentifier,
                                                [@rowguid68] uniqueidentifier, [@rowguid69] uniqueidentifier,
                                                [@rowguid7] uniqueidentifier, [@rowguid70] uniqueidentifier,
                                                [@rowguid71] uniqueidentifier, [@rowguid72] uniqueidentifier,
                                                [@rowguid73] uniqueidentifier, [@rowguid74] uniqueidentifier,
                                                [@rowguid75] uniqueidentifier, [@rowguid76] uniqueidentifier,
                                                [@rowguid77] uniqueidentifier, [@rowguid78] uniqueidentifier,
                                                [@rowguid79] uniqueidentifier, [@rowguid8] uniqueidentifier,
                                                [@rowguid80] uniqueidentifier, [@rowguid81] uniqueidentifier,
                                                [@rowguid82] uniqueidentifier, [@rowguid83] uniqueidentifier,
                                                [@rowguid84] uniqueidentifier, [@rowguid85] uniqueidentifier,
                                                [@rowguid86] uniqueidentifier, [@rowguid87] uniqueidentifier,
                                                [@rowguid88] uniqueidentifier, [@rowguid89] uniqueidentifier,
                                                [@rowguid9] uniqueidentifier, [@rowguid90] uniqueidentifier,
                                                [@rowguid91] uniqueidentifier, [@rowguid92] uniqueidentifier,
                                                [@rowguid93] uniqueidentifier, [@rowguid94] uniqueidentifier,
                                                [@rowguid95] uniqueidentifier, [@rowguid96] uniqueidentifier,
                                                [@rowguid97] uniqueidentifier, [@rowguid98] uniqueidentifier,
                                                [@rowguid99] uniqueidentifier,
                                                [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSgetonerow([@pubid] uniqueidentifier, [@rowguid] uniqueidentifier,
                                    [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSgetonerowlightweight([@pubid] uniqueidentifier, [@rowguid] uniqueidentifier,
                                               [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSgetpeerconflictrow([@conflict_table] nvarchar(270), [@origin_datasource] nvarchar(32),
                                             [@originator_id] nvarchar(32), [@row_id] nvarchar(32),
                                             [@tran_id] nvarchar(32)) as -- missing source code
go

create procedure sys.sp_MSgetpeerlsns([@publication] sysname, [@xlockrows] bit) as -- missing source code
go

create procedure sys.sp_MSgetpeertopeercommands([@article] sysname, [@publication] sysname, [@script_txt] nvarchar(max),
                                                [@snapshot_lsn] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSgetpeerwinnerrow([@conflict_table] nvarchar(270), [@originator_id] nvarchar(32),
                                           [@row_id] nvarchar(19)) as -- missing source code
go

create procedure sys.sp_MSgetpubinfo([@pubdb] sysname, [@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_MSgetreplicainfo([@compatlevel] int, [@datasource_path] nvarchar(255), [@datasource_type] int,
                                         [@db_name] sysname, [@publication] sysname, [@publisher] sysname,
                                         [@publisher_db] sysname, [@server_name] sysname) as -- missing source code
go

create procedure sys.sp_MSgetreplicastate([@pubid] uniqueidentifier, [@replicastate] uniqueidentifier,
                                          [@subid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSgetrowmetadata([@colv] varbinary(2953), [@compatlevel] int, [@generation] bigint,
                                         [@lineage] varbinary(311), [@pubid] uniqueidentifier,
                                         [@rowguid] uniqueidentifier, [@tablenick] int,
                                         [@type] tinyint) as -- missing source code
go

create procedure sys.sp_MSgetrowmetadatalightweight([@changedcolumns] varbinary(128), [@columns_enumeration] tinyint,
                                                    [@pubid] uniqueidentifier, [@rowguid] uniqueidentifier,
                                                    [@rowvector] varbinary(11), [@tablenick] int,
                                                    [@type] tinyint) as -- missing source code
go

create procedure sys.sp_MSgetsetupbelong_cost() as -- missing source code
go

create procedure sys.sp_MSgetsubscriberinfo([@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSgetsupportabilitysettings([@compatlevel] int, [@db_name] sysname, [@publication] sysname,
                                                    [@publisher] sysname, [@publisher_db] sysname,
                                                    [@server_name] sysname,
                                                    [@web_server] sysname) as -- missing source code
go

create procedure sys.sp_MSgettrancftsrcrow([@conflict_table] nvarchar(270), [@is_debug] bit, [@is_subscriber] bit,
                                           [@row_id] sysname, [@tran_id] sysname) as -- missing source code
go

create procedure sys.sp_MSgettranconflictrow([@conflict_table] nvarchar(270), [@is_subscriber] bit, [@row_id] sysname,
                                             [@tran_id] sysname) as -- missing source code
go

create procedure sys.sp_MSgetversion() as -- missing source code
go

create procedure sys.sp_MSgrantconnectreplication([@user_name] sysname) as -- missing source code
go

create procedure sys.sp_MShaschangeslightweight([@haschanges] int, [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MShasdbaccess() as -- missing source code
go

create procedure sys.sp_MShelp_article([@article] sysname, [@publication] sysname, [@publisher] sysname,
                                       [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelp_distdb([@publisher_name] sysname) as -- missing source code
go

create procedure sys.sp_MShelp_distribution_agentid([@anonymous_subid] uniqueidentifier, [@publication] sysname,
                                                    [@publisher_db] sysname, [@publisher_id] smallint,
                                                    [@reinitanon] bit, [@subscriber_db] sysname,
                                                    [@subscriber_id] smallint, [@subscriber_name] sysname,
                                                    [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MShelp_identity_property([@ownername] sysname, [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MShelp_logreader_agentid([@publisher_db] sysname, [@publisher_id] smallint) as -- missing source code
go

create procedure sys.sp_MShelp_merge_agentid([@publication] sysname, [@publisher_db] sysname, [@publisher_id] smallint,
                                             [@subscriber] sysname, [@subscriber_db] sysname, [@subscriber_id] smallint,
                                             [@subscriber_version] int) as -- missing source code
go

create procedure sys.sp_MShelp_profile([@agent_id] int, [@agent_type] int, [@profile_name] sysname) as -- missing source code
go

create procedure sys.sp_MShelp_profilecache([@profile_name] sysname) as -- missing source code
go

create procedure sys.sp_MShelp_publication([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelp_repl_agent([@agent_type] int, [@publication] sysname, [@publisher] sysname,
                                          [@publisher_db] sysname, [@subscriber] sysname,
                                          [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelp_replication_status([@agent_type] int, [@exclude_anonymous] bit, [@publication] sysname,
                                                  [@publisher] sysname,
                                                  [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelp_replication_table([@table_name] sysname, [@table_owner] sysname) as -- missing source code
go

create procedure sys.sp_MShelp_snapshot_agent([@agent_id] int) as -- missing source code
go

create procedure sys.sp_MShelp_snapshot_agentid([@dynamic_filter_hostname] sysname, [@dynamic_filter_login] sysname,
                                                [@dynamic_snapshot_location] nvarchar(255), [@job_id] binary(16),
                                                [@publication] sysname, [@publisher_db] sysname,
                                                [@publisher_id] smallint) as -- missing source code
go

create procedure sys.sp_MShelp_subscriber_info([@found] int, [@publisher] sysname, [@show_password] bit,
                                               [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_MShelp_subscription([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                            [@subscriber] sysname, [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelp_subscription_status([@independent_agent] bit, [@out_of_date] int, [@publication] sysname,
                                                   [@publisher] sysname, [@publisher_db] sysname, [@retention] int,
                                                   [@subscriber] sysname,
                                                   [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelpcolumns([@flags] int, [@flags2] int, [@orderby] nvarchar(10),
                                      [@tablename] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MShelpconflictpublications([@publication_type] varchar(9)) as -- missing source code
go

create procedure sys.sp_MShelpcreatebeforetable([@newname] sysname, [@objid] int) as -- missing source code
go

create procedure sys.sp_MShelpdestowner([@spname] sysname) as -- missing source code
go

create procedure sys.sp_MShelpdynamicsnapshotjobatdistributor([@active_end_date] int, [@active_end_time_of_day] int,
                                                              [@active_start_date] int, [@active_start_time_of_day] int,
                                                              [@dynamic_filter_hostname] sysname,
                                                              [@dynamic_filter_login] sysname,
                                                              [@frequency_interval] int,
                                                              [@frequency_recurrence_factor] int,
                                                              [@frequency_relative_interval] int,
                                                              [@frequency_subday] int, [@frequency_subday_interval] int,
                                                              [@frequency_type] int, [@publication] sysname,
                                                              [@publisher] sysname,
                                                              [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelpfulltextindex([@tablename] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MShelpfulltextscript([@tablename] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MShelpindex([@flags] int, [@indexname] nvarchar(258),
                                    [@tablename] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MShelplogreader_agent([@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelpmergearticles([@compatibility_level] int, [@pubidin] uniqueidentifier,
                                            [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MShelpmergeconflictcounts([@logical_record_conflicts] int, [@publication_name] sysname,
                                                  [@publisher] sysname,
                                                  [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelpmergedynamicsnapshotjob([@dynamic_snapshot_jobid] uniqueidentifier,
                                                      [@dynamic_snapshot_jobname] sysname,
                                                      [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MShelpmergeidentity([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MShelpmergeschemaarticles([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MShelpobjectpublications([@object_name] sysname) as -- missing source code
go

create procedure sys.sp_MShelpreplicationtriggers([@object_name] sysname, [@object_schema] sysname) as -- missing source code
go

create procedure sys.sp_MShelpsnapshot_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelpsummarypublication([@oename] nvarchar(260), [@oetype] nvarchar(100)) as -- missing source code
go

create procedure sys.sp_MShelptracertokenhistory([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                 [@tracer_id] int) as -- missing source code
go

create procedure sys.sp_MShelptracertokens([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelptranconflictcounts([@originator_id] nvarchar(32), [@publication_name] sysname,
                                                 [@publisher] sysname,
                                                 [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MShelptype([@flags] nvarchar(10), [@typename] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MShelpvalidationdate([@publication] sysname, [@subscriber] sysname,
                                             [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSindexspace([@index_name] nvarchar(258), [@tablename] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MSinit_publication_access([@initinfo] nvarchar(max), [@publication] sysname,
                                                  [@publisher] sysname, [@publisher_db] sysname,
                                                  [@skip] bit) as -- missing source code
go

create procedure sys.sp_MSinit_subscription_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                  [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MSinitdynamicsubscriber([@blob_cols_at_the_end] bit, [@compatlevel] int,
                                                [@enumentirerowmetadata] bit, [@maxrows] int, [@pubid] uniqueidentifier,
                                                [@rowguid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSinsert_identity([@identity_range] bigint, [@identity_support] int, [@max_identity] bigint,
                                          [@next_seed] bigint, [@pub_identity_range] bigint, [@publisher] sysname,
                                          [@publisher_db] sysname, [@tablename] sysname,
                                          [@threshold] int) as -- missing source code
go

create procedure sys.sp_MSinsertdeleteconflict([@compatlevel] int, [@conflict_type] int, [@conflicts_logged] int,
                                               [@lineage] varbinary(311), [@origin_datasource] nvarchar(255),
                                               [@pubid] uniqueidentifier, [@reason_code] int,
                                               [@reason_text] nvarchar(720), [@rowguid] uniqueidentifier,
                                               [@source_id] uniqueidentifier,
                                               [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSinserterrorlineage([@compatlevel] int, [@lineage] varbinary(311), [@rowguid] uniqueidentifier,
                                             [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSinsertgenerationschemachanges([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSinsertgenhistory([@artnick] int, [@compatlevel] int, [@gen] bigint,
                                           [@guidsrc] uniqueidentifier, [@nicknames] varbinary(1000),
                                           [@pubid] uniqueidentifier,
                                           [@pubid_ins] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSinsertlightweightschemachange([@pubid] uniqueidentifier, [@schemaguid] uniqueidentifier,
                                                        [@schemaversion] int) as -- missing source code
go

create procedure sys.sp_MSinsertschemachange([@artid] uniqueidentifier, [@pubid] uniqueidentifier,
                                             [@schemaguid] uniqueidentifier, [@schemasubtype] int,
                                             [@schematext] nvarchar(max), [@schematype] int, [@schemaversion] int,
                                             [@update_schemaversion] tinyint) as -- missing source code
go

create procedure sys.sp_MSinvalidate_snapshot([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSisnonpkukupdateinconflict([@artid] int, [@bitmap] varbinary(4000), [@pubid] int) as -- missing source code
go

create procedure sys.sp_MSispeertopeeragent([@agent_id] int, [@is_p2p] int) as -- missing source code
go

create procedure sys.sp_MSispkupdateinconflict([@artid] int, [@bitmap] varbinary(4000), [@pubid] int) as -- missing source code
go

create procedure sys.sp_MSispublicationqueued([@allow_queued_tran] bit, [@publication] sysname, [@publisher] sysname,
                                              [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSisreplmergeagent([@at_publisher] bit, [@is_merge] bit) as -- missing source code
go

create procedure sys.sp_MSissnapshotitemapplied([@snapshot_progress_token] nvarchar(500),
                                                [@snapshot_session_token] nvarchar(260)) as -- missing source code
go

create procedure sys.sp_MSkilldb([@dbname] nvarchar(258)) as -- missing source code
go

create procedure sys.sp_MSlock_auto_sub([@publication] sysname, [@publisher_db] sysname, [@publisher_id] int,
                                        [@reset] bit) as -- missing source code
go

create procedure sys.sp_MSlock_distribution_agent([@id] int, [@mode] int) as -- missing source code
go

create procedure sys.sp_MSlocktable([@ownername] sysname, [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSloginmappings([@flags] int, [@loginname] nvarchar(258)) as -- missing source code
go

create procedure sys.sp_MSmakearticleprocs([@artid] uniqueidentifier, [@pubid] uniqueidentifier,
                                           [@recreate_conflict_proc] bit) as -- missing source code
go

create procedure sys.sp_MSmakebatchinsertproc([@artid] uniqueidentifier, [@destination_owner] sysname,
                                              [@generate_subscriber_proc] bit, [@ownername] sysname,
                                              [@procname] sysname, [@pubid] uniqueidentifier,
                                              [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSmakebatchupdateproc([@artid] uniqueidentifier, [@destination_owner] sysname,
                                              [@generate_subscriber_proc] bit, [@ownername] sysname,
                                              [@procname] sysname, [@pubid] uniqueidentifier,
                                              [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSmakeconflictinsertproc([@basetableid] int, [@generate_subscriber_proc] bit,
                                                 [@ownername] sysname, [@procname] sysname, [@pubid] uniqueidentifier,
                                                 [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSmakectsview([@create_dynamic_views] bit, [@ctsview] sysname,
                                      [@dynamic_snapshot_views_table_name] sysname, [@max_bcp_gen] bigint,
                                      [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSmakedeleteproc([@artid] uniqueidentifier, [@destination_owner] sysname,
                                         [@generate_subscriber_proc] bit, [@ownername] sysname, [@procname] sysname,
                                         [@pubid] uniqueidentifier, [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSmakedynsnapshotvws([@dynamic_filter_login] sysname,
                                             [@dynamic_snapshot_views_table_name] sysname,
                                             [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSmakeexpandproc([@filterid] int, [@procname] sysname, [@pubname] sysname) as -- missing source code
go

create procedure sys.sp_MSmakegeneration([@commongen] bigint, [@commongenguid] uniqueidentifier, [@commongenvalid] int,
                                         [@compatlevel] int, [@gencheck] int) as -- missing source code
go

create procedure sys.sp_MSmakeinsertproc([@artid] uniqueidentifier, [@destination_owner] sysname,
                                         [@generate_downlevel_procs] bit, [@generate_subscriber_proc] bit,
                                         [@ownername] sysname, [@procname] sysname, [@pubid] uniqueidentifier,
                                         [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSmakemetadataselectproc([@artid] uniqueidentifier, [@destination_owner] sysname,
                                                 [@generate_subscriber_proc] bit, [@ownername] sysname,
                                                 [@procname] sysname, [@pubid] uniqueidentifier,
                                                 [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSmakeselectproc([@artid] uniqueidentifier, [@destination_owner] sysname,
                                         [@generate_downlevel_procs] bit, [@generate_subscriber_proc] bit,
                                         [@ownername] sysname, [@procname] sysname, [@pubid] uniqueidentifier,
                                         [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSmakesystableviews([@create_dynamic_views] bit, [@dynamic_snapshot_views_table_name] sysname,
                                            [@max_bcp_gen] bigint, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSmakeupdateproc([@artid] uniqueidentifier, [@destination_owner] sysname,
                                         [@generate_downlevel_procs] bit, [@generate_subscriber_proc] bit,
                                         [@ownername] sysname, [@procname] sysname, [@pubid] uniqueidentifier,
                                         [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSmap_partitionid_to_generations([@partition_id] int) as -- missing source code
go

create procedure sys.sp_MSmarkreinit([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                     [@reset_reinit] int, [@subscriber] sysname,
                                     [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSmatchkey([@col1] nvarchar(258), [@col10] nvarchar(258), [@col11] nvarchar(258),
                                   [@col12] nvarchar(258), [@col13] nvarchar(258), [@col14] nvarchar(258),
                                   [@col15] nvarchar(258), [@col16] nvarchar(258), [@col2] nvarchar(258),
                                   [@col3] nvarchar(258), [@col4] nvarchar(258), [@col5] nvarchar(258),
                                   [@col6] nvarchar(258), [@col7] nvarchar(258), [@col8] nvarchar(258),
                                   [@col9] nvarchar(258), [@tablename] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MSmerge_alterschemaonly([@objecttype] varchar(32), [@objid] int,
                                                [@pass_through_scripts] nvarchar(max),
                                                [@qual_object_name] nvarchar(512)) as -- missing source code
go

create procedure sys.sp_MSmerge_altertrigger([@objid] int, [@pass_through_scripts] nvarchar(max),
                                             [@qual_object_name] nvarchar(512),
                                             [@target_object_name] nvarchar(512)) as -- missing source code
go

create procedure sys.sp_MSmerge_alterview([@objecttype] varchar(32), [@objid] int,
                                          [@pass_through_scripts] nvarchar(max),
                                          [@qual_object_name] nvarchar(512)) as -- missing source code
go

create procedure sys.sp_MSmerge_ddldispatcher([@EventData] xml, [@procmapid] int) as -- missing source code
go

create procedure sys.sp_MSmerge_getgencount([@gencount] int, [@genlist] varchar(8000)) as -- missing source code
go

create procedure sys.sp_MSmerge_getgencur_public([@changecount] int, [@gen_cur] bigint, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSmerge_is_snapshot_required([@publication] sysname, [@publisher] sysname,
                                                     [@publisher_db] sysname, [@run_at_subscriber] bit,
                                                     [@schemaversion] bigint, [@subscriber] sysname,
                                                     [@subscriber_db] sysname,
                                                     [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MSmerge_log_identity_range_allocations([@article] sysname, [@is_pub_range] bit,
                                                               [@next_range_begin] numeric(38),
                                                               [@next_range_end] numeric(38), [@publication] sysname,
                                                               [@publisher] sysname, [@publisher_db] sysname,
                                                               [@range_begin] numeric(38), [@range_end] numeric(38),
                                                               [@ranges_allocated] tinyint, [@subscriber] sysname,
                                                               [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSmerge_parsegenlist([@gendeclarelist] varchar(max), [@genlist] varchar(8000),
                                             [@genselectlist] varchar(max),
                                             [@genunionlist] varchar(max)) as -- missing source code
go

create procedure sys.sp_MSmerge_upgrade_subscriber([@upgrade_done] bit, [@upgrade_metadata] bit) as -- missing source code
go

create procedure sys.sp_MSmergesubscribedb([@create_ddl_triggers] bit, [@value] sysname,
                                           [@whattocreate] smallint) as -- missing source code
go

create procedure sys.sp_MSmergeupdatelastsyncinfo([@last_sync_status] int, [@last_sync_summary] sysname,
                                                  [@subid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSneedmergemetadataretentioncleanup([@needcleanup] bit, [@replicaid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSobjectprivs([@flags] int, [@grantee] nvarchar(258), [@mode] nvarchar(10), [@objid] int,
                                      [@objname] nvarchar(776), [@prottype] int, [@rollup] int,
                                      [@srvpriv] int) as -- missing source code
go

create procedure sys.sp_MSpeerapplyresponse([@originator] sysname, [@originator_db] sysname, [@request_id] int,
                                            [@response_db] sysname, [@response_srvr] sysname) as -- missing source code
go

create procedure sys.sp_MSpeerapplytopologyinfo([@connection_info] xml, [@originator] sysname, [@originator_db] sysname,
                                                [@request_id] int, [@response_conflict_retention] int,
                                                [@response_db] sysname, [@response_originator_id] int,
                                                [@response_srvr] sysname,
                                                [@response_srvr_version] int) as -- missing source code
go

create procedure sys.sp_MSpeerconflictdetection_statuscollection_applyresponse([@conflictdetection_enabled] bit,
                                                                               [@originator_db] sysname,
                                                                               [@originator_node] sysname,
                                                                               [@peer_conflict_retention] int,
                                                                               [@peer_continue_onconflict] bit,
                                                                               [@peer_db] sysname,
                                                                               [@peer_db_version] int,
                                                                               [@peer_histids] nvarchar(max),
                                                                               [@peer_node] sysname,
                                                                               [@peer_originator_id] int,
                                                                               [@request_id] int) as -- missing source code
go

create procedure sys.sp_MSpeerconflictdetection_statuscollection_sendresponse([@originator_db] sysname,
                                                                              [@originator_node] sysname,
                                                                              [@publication] sysname,
                                                                              [@request_id] int) as -- missing source code
go

create procedure sys.sp_MSpeerconflictdetection_topology_applyresponse([@peer_db] sysname, [@peer_node] sysname,
                                                                       [@peer_subscriptions] nvarchar(max),
                                                                       [@peer_version] int,
                                                                       [@request_id] int) as -- missing source code
go

create procedure sys.sp_MSpeerdbinfo([@current_version] int, [@is_p2p] bit) as -- missing source code
go

create procedure sys.sp_MSpeersendresponse([@originator] sysname, [@originator_db] sysname,
                                           [@originator_publication] sysname,
                                           [@request_id] int) as -- missing source code
go

create procedure sys.sp_MSpeersendtopologyinfo([@originator] sysname, [@originator_db] sysname,
                                               [@originator_publication] sysname,
                                               [@request_id] int) as -- missing source code
go

create procedure sys.sp_MSpeertopeerfwdingexec([@change_results_originator] bit, [@command] nvarchar(max),
                                               [@execute] bit, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSpost_auto_proc([@alter] bit, [@artid] int, [@artname] sysname, [@dbname] sysname,
                                         [@for_p2p_ddl] bit, [@format] int, [@has_ident] bit, [@has_ts] bit,
                                         [@procmapid] int, [@pubid] int, [@publisher] sysname,
                                         [@pubname] sysname) as -- missing source code
go

create procedure sys.sp_MSpostapplyscript_forsubscriberprocs([@procsuffix] sysname) as -- missing source code
go

create procedure sys.sp_MSprep_exclusive([@objid] int, [@objname] sysname) as -- missing source code
go

create procedure sys.sp_MSprepare_mergearticle([@publication] sysname, [@qualified_tablename] nvarchar(270),
                                               [@source_owner] sysname,
                                               [@source_table] sysname) as -- missing source code
go

create procedure sys.sp_MSprofile_in_use([@profile_id] int, [@tablename] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_MSproxiedmetadata([@compatlevel] int, [@proxied_colv] varbinary(2953),
                                          [@proxied_lineage] varbinary(311), [@proxy_logical_record_lineage] bit,
                                          [@rowguid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSproxiedmetadatabatch([@compatlevel] int, [@proxied_colv] varbinary(2953),
                                               [@proxied_lineage] varbinary(311), [@proxy_logical_record_lineage] bit,
                                               [@rowguid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSproxiedmetadatalightweight([@acknowledge_only] bit, [@pubid] uniqueidentifier,
                                                     [@rowguid] uniqueidentifier, [@rowvector] varbinary(11),
                                                     [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSpub_adjust_identity([@artid] int, [@max_identity] bigint) as -- missing source code
go

create procedure sys.sp_MSpublication_access([@has_access] bit, [@login] sysname, [@operation] nvarchar(20),
                                             [@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                             [@skip] bit) as -- missing source code
go

create procedure sys.sp_MSpublicationcleanup([@force_preserve_rowguidcol] bit, [@ignore_merge_metadata] bit,
                                             [@publication] sysname, [@publisher] sysname,
                                             [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSpublicationview([@articlename] sysname, [@force_flag] int, [@max_network_optimization] bit,
                                          [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSquery_syncstates([@publisher_db] sysname, [@publisher_id] smallint) as -- missing source code
go

create procedure sys.sp_MSquerysubtype([@pubid] uniqueidentifier, [@subscriber] sysname,
                                       [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSrecordsnapshotdeliveryprogress([@snapshot_progress_token] nvarchar(500),
                                                         [@snapshot_session_token] nvarchar(260)) as -- missing source code
go

create procedure sys.sp_MSreenable_check([@objname] sysname, [@objowner] sysname) as -- missing source code
go

create procedure sys.sp_MSrefresh_anonymous([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSrefresh_publisher_idrange([@artid] uniqueidentifier, [@qualified_object_name] nvarchar(517),
                                                    [@ranges_needed] tinyint, [@refresh_check_constraint] bit,
                                                    [@subid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSregenerate_mergetriggersprocs([@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSregisterdynsnapseqno([@dynsnapseqno] uniqueidentifier,
                                               [@snapshot_session_token] nvarchar(260)) as -- missing source code
go

create procedure sys.sp_MSregistermergesnappubid([@pubid] uniqueidentifier, [@snapshot_session_token] nvarchar(260)) as -- missing source code
go

create procedure sys.sp_MSregistersubscription([@distributor] sysname, [@distributor_login] sysname,
                                               [@distributor_password] nvarchar(524), [@distributor_security_mode] int,
                                               [@failover_mode] int, [@hostname] sysname, [@independent_agent] int,
                                               [@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                               [@publisher_login] sysname, [@publisher_password] nvarchar(524),
                                               [@publisher_security_mode] int, [@replication_type] int,
                                               [@subscriber] sysname, [@subscriber_db] sysname,
                                               [@subscriber_login] sysname, [@subscriber_password] nvarchar(524),
                                               [@subscriber_security_mode] int, [@subscription_id] uniqueidentifier,
                                               [@subscription_type] int, [@use_interactive_resolver] int,
                                               [@use_web_sync] bit) as -- missing source code
go

create procedure sys.sp_MSreinit_failed_subscriptions([@failure_level] int) as -- missing source code
go

create procedure sys.sp_MSreinit_hub([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                     [@upload_first] bit) as -- missing source code
go

create procedure sys.sp_MSreinit_subscription([@publication] sysname, [@publisher_db] sysname,
                                              [@publisher_name] sysname, [@subscriber_db] sysname,
                                              [@subscriber_name] sysname) as -- missing source code
go

create procedure sys.sp_MSreinitoverlappingmergepublications([@pubid] uniqueidentifier, [@upload_before_reinit] bit) as -- missing source code
go

create procedure sys.sp_MSreleaseSlotLock([@DbPrincipal] sysname, [@process_name] sysname) as -- missing source code
go

create procedure sys.sp_MSreleasedynamicsnapshotapplock([@partition_id] int, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSreleasemakegenerationapplock() as -- missing source code
go

create procedure sys.sp_MSreleasemergeadminapplock([@lockowner] nvarchar(32)) as -- missing source code
go

create procedure sys.sp_MSreleasesnapshotdeliverysessionlock() as -- missing source code
go

create procedure sys.sp_MSremove_mergereplcommand([@article] sysname, [@publication] sysname, [@schematype] int) as -- missing source code
go

create procedure sys.sp_MSremoveoffloadparameter([@agenttype] nvarchar(20), [@job_id] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSrepl_FixPALRole([@pubid] uniqueidentifier, [@role] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_IsLastPubInSharedSubscription([@publication] sysname, [@subscriber] sysname,
                                                             [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_IsUserInAnyPAL([@raise_error] bit) as -- missing source code
go

create procedure sys.sp_MSrepl_PAL_rolecheck([@artid] uniqueidentifier, [@objid] int, [@partition_id] int,
                                             [@pubid] uniqueidentifier, [@publication] sysname,
                                             [@repid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSrepl_agentstatussummary([@log_comments] nvarchar(255), [@log_duration] int, [@log_status] int,
                                                  [@log_time] datetime, [@publication] sysname, [@publisher] sysname,
                                                  [@publisher_db] sysname, [@snap_comments] nvarchar(255),
                                                  [@snap_duration] int, [@snap_status] int,
                                                  [@snap_time] datetime) as -- missing source code
go

create procedure sys.sp_MSrepl_backup_complete() as -- missing source code
go

create procedure sys.sp_MSrepl_backup_start() as -- missing source code
go

create procedure sys.sp_MSrepl_check_publisher([@connect_timeout] int, [@login] nvarchar(255),
                                               [@password] nvarchar(255), [@publisher] sysname,
                                               [@publisher_type] sysname,
                                               [@security_mode] bit) as -- missing source code
go

create procedure sys.sp_MSrepl_createdatatypemappings() as -- missing source code
go

create procedure sys.sp_MSrepl_distributionagentstatussummary([@distribution_duration] int,
                                                              [@distribution_message] nvarchar(255),
                                                              [@distribution_status] int, [@distribution_time] datetime,
                                                              [@publication] sysname, [@publisher] sysname,
                                                              [@publisher_db] sysname, [@subscriber] sysname,
                                                              [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_dropdatatypemappings() as -- missing source code
go

create procedure sys.sp_MSrepl_enumarticlecolumninfo([@article] sysname, [@defaults] bit, [@publication] sysname,
                                                     [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_enumpublications([@reserved] bit) as -- missing source code
go

create procedure sys.sp_MSrepl_enumpublishertables([@publisher] sysname, [@silent] bit) as -- missing source code
go

create procedure sys.sp_MSrepl_enumsubscriptions([@publication] sysname, [@publisher] sysname, [@reserved] bit) as -- missing source code
go

create procedure sys.sp_MSrepl_enumtablecolumninfo([@owner] sysname, [@publisher] sysname, [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_getdistributorinfo([@dist_listener] sysname, [@distribdb] sysname,
                                                  [@distributor] sysname, [@is_DistribDB_in_AG] bit,
                                                  [@local] nvarchar(5), [@publisher] sysname, [@publisher_id] int,
                                                  [@publisher_type] sysname, [@rpcsrvname] sysname, [@version] int,
                                                  [@working_directory] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_MSrepl_getpkfkrelation([@filtered_table] nvarchar(400), [@joined_table] nvarchar(400)) as -- missing source code
go

create procedure sys.sp_MSrepl_gettype_mappings([@dbms_name] sysname, [@dbms_version] sysname, [@source_prec] int,
                                                [@sql_type] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_helparticlermo([@article] sysname, [@found] int, [@publication] sysname,
                                              [@publisher] sysname, [@returnfilter] bit) as -- missing source code
go

create procedure sys.sp_MSrepl_init_backup_lsns() as -- missing source code
go

create procedure sys.sp_MSrepl_isdbowner([@dbname] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_linkedservers_rowset([@agent_id] int, [@agent_type] int, [@srvname] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_mergeagentstatussummary([@merge_duration] int, [@merge_message] nvarchar(1000),
                                                       [@merge_percent_complete] decimal(5, 2), [@merge_status] int,
                                                       [@merge_time] datetime, [@publication] sysname,
                                                       [@publisher] sysname, [@publisher_db] sysname,
                                                       [@subscriber] sysname,
                                                       [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_monitor_job_at_failover([@all] bit, [@database_name] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_raiserror([@agent] sysname, [@agent_name] nvarchar(100), [@article] sysname,
                                         [@message] nvarchar(255), [@publication] sysname, [@status] int,
                                         [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_reinit_jobsync_table([@all] bit, [@database_name] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_schema([@artid] int, [@column] sysname, [@operation] int, [@pubname] sysname,
                                      [@qual_source_object] nvarchar(517), [@schema_change_script] nvarchar(4000),
                                      [@typetext] nvarchar(3000)) as -- missing source code
go

create procedure sys.sp_MSrepl_setNFR([@object_name] sysname, [@schema] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_snapshot_helparticlecolumns([@article] sysname, [@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_snapshot_helppublication([@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_startup_internal() as -- missing source code
go

create procedure sys.sp_MSrepl_subscription_rowset([@agent_id] int, [@agent_type] int, [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_testadminconnection([@distributor] sysname, [@password] sysname) as -- missing source code
go

create procedure sys.sp_MSrepl_testconnection([@connect_timeout] int, [@login] sysname, [@password] sysname,
                                              [@publisher] sysname, [@publisher_type] sysname,
                                              [@security_mode] bit) as -- missing source code
go

create procedure sys.sp_MSreplagentjobexists([@exists] bit, [@frompublisher] bit, [@independent_agent] bit,
                                             [@job_id] uniqueidentifier, [@job_name] sysname,
                                             [@job_step_uid] uniqueidentifier, [@proxy_id] int, [@publication] sysname,
                                             [@publisher] sysname, [@publisher_db] sysname, [@publisher_id] int,
                                             [@subscriber] sysname, [@subscriber_db] sysname, [@subscriber_id] int,
                                             [@type] int) as -- missing source code
go

create procedure sys.sp_MSreplcheck_permission([@objid] int, [@permissions] int, [@type] int) as -- missing source code
go

create procedure sys.sp_MSreplcheck_pull([@given_login] sysname, [@pubid] uniqueidentifier, [@publication] sysname,
                                         [@publisher] sysname, [@raise_fatal_error] bit) as -- missing source code
go

create procedure sys.sp_MSreplcheck_subscribe() as -- missing source code
go

create procedure sys.sp_MSreplcheck_subscribe_withddladmin() as -- missing source code
go

create procedure sys.sp_MSreplcheckoffloadserver([@offloadserver] sysname) as -- missing source code
go

create procedure sys.sp_MSreplcopyscriptfile([@directory] nvarchar(4000), [@scriptfile] nvarchar(4000)) as -- missing source code
go

create procedure sys.sp_MSreplraiserror([@errorid] int, [@param1] sysname, [@param2] sysname, [@param3] int) as -- missing source code
go

create procedure sys.sp_MSreplremoveuncdir([@dir] nvarchar(260), [@ignore_errors] bit) as -- missing source code
go

create procedure sys.sp_MSreplupdateschema([@object_name] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MSrequestreenumeration([@rowguid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSrequestreenumeration_lightweight([@rowguid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSreset_attach_state([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                             [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MSreset_queued_reinit([@artid] int, [@subscriber] sysname, [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSreset_subscription([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                             [@subscriber] sysname, [@subscriber_db] sysname,
                                             [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MSreset_subscription_seqno([@agent_id] int, [@get_snapshot] bit) as -- missing source code
go

create procedure sys.sp_MSreset_synctran_bit([@owner] sysname, [@table] sysname) as -- missing source code
go

create procedure sys.sp_MSreset_transaction([@publisher] sysname, [@publisher_db] sysname,
                                            [@xact_seqno] varbinary(10)) as -- missing source code
go

create procedure sys.sp_MSresetsnapshotdeliveryprogress([@snapshot_session_token] nvarchar(260)) as -- missing source code
go

create procedure sys.sp_MSrestoresavedforeignkeys([@program_name] sysname) as -- missing source code
go

create procedure sys.sp_MSretrieve_publication_attributes([@database] sysname, [@name] sysname) as -- missing source code
go

create procedure sys.sp_MSscript_article_view([@artid] int, [@include_timestamps] bit, [@view_name] sysname) as -- missing source code
go

create procedure sys.sp_MSscript_dri([@article] sysname, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSscript_pub_upd_trig([@alter] bit, [@article] sysname, [@procname] sysname,
                                              [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSscript_sync_del_proc([@alter] bit, [@article] sysname, [@procname] sysname,
                                               [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSscript_sync_del_trig([@agent_id] int, [@cftproc] sysname, [@falter] bit,
                                               [@filter_clause] nvarchar(4000), [@identity_col] sysname, [@objid] int,
                                               [@primary_key_bitmap] varbinary(4000), [@proc_owner] sysname,
                                               [@procname] sysname, [@publication] sysname, [@publisher] sysname,
                                               [@publisher_db] sysname, [@pubversion] int, [@trigname] sysname,
                                               [@ts_col] sysname) as -- missing source code
go

create procedure sys.sp_MSscript_sync_ins_proc([@alter] bit, [@article] sysname, [@procname] sysname,
                                               [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSscript_sync_ins_trig([@agent_id] int, [@cftproc] sysname, [@falter] bit,
                                               [@filter_clause] nvarchar(4000), [@identity_col] sysname, [@objid] int,
                                               [@primary_key_bitmap] varbinary(4000), [@proc_owner] sysname,
                                               [@procname] sysname, [@publication] sysname, [@publisher] sysname,
                                               [@publisher_db] sysname, [@pubversion] int, [@trigname] sysname,
                                               [@ts_col] sysname) as -- missing source code
go

create procedure sys.sp_MSscript_sync_upd_proc([@alter] bit, [@article] sysname, [@procname] sysname,
                                               [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSscript_sync_upd_trig([@agent_id] int, [@cftproc] sysname, [@falter] bit,
                                               [@filter_clause] nvarchar(4000), [@identity_col] sysname, [@objid] int,
                                               [@primary_key_bitmap] varbinary(4000), [@proc_owner] sysname,
                                               [@procname] sysname, [@publication] sysname, [@publisher] sysname,
                                               [@publisher_db] sysname, [@pubversion] int, [@trigname] sysname,
                                               [@ts_col] sysname) as -- missing source code
go

create procedure sys.sp_MSscriptcustomdelproc([@artid] int, [@inDDLrepl] bit, [@publisher] sysname,
                                              [@publishertype] tinyint, [@usesqlclr] bit) as -- missing source code
go

create procedure sys.sp_MSscriptcustominsproc([@artid] int, [@inDDLrepl] bit, [@publisher] sysname,
                                              [@publishertype] tinyint, [@usesqlclr] bit) as -- missing source code
go

create procedure sys.sp_MSscriptcustomupdproc([@artid] int, [@inDDLrepl] bit, [@publisher] sysname,
                                              [@publishertype] tinyint, [@usesqlclr] bit) as -- missing source code
go

create procedure sys.sp_MSscriptdatabase([@dbname] nvarchar(258)) as -- missing source code
go

create procedure sys.sp_MSscriptdb_worker() as -- missing source code
go

create procedure sys.sp_MSscriptforeignkeyrestore([@constraint_name] sysname, [@delete_referential_action] tinyint,
                                                  [@is_not_for_replication] bit, [@is_not_trusted] bit,
                                                  [@parent_name] sysname, [@parent_schema] sysname,
                                                  [@program_name] sysname, [@referenced_object_name] sysname,
                                                  [@referenced_object_schema] sysname,
                                                  [@update_referential_action] tinyint) as -- missing source code
go

create procedure sys.sp_MSscriptsubscriberprocs([@article] sysname, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSscriptviewproc([@artid] uniqueidentifier, [@ownername] sysname, [@procname] sysname,
                                         [@pubid] uniqueidentifier, [@rgcol] sysname,
                                         [@viewname] sysname) as -- missing source code
go

create procedure sys.sp_MSsendtosqlqueue([@cmdstate] bit, [@commandtype] int, [@data] varbinary(8000), [@datalen] int,
                                         [@objid] int, [@owner] sysname, [@publication] sysname, [@publisher] sysname,
                                         [@publisher_db] sysname, [@tranid] sysname) as -- missing source code
go

create procedure sys.sp_MSset_dynamic_filter_options([@dont_raise_error] bit, [@dynamic_filters] bit,
                                                     [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSset_logicalrecord_metadata([@logical_record_lineage] varbinary(311), [@parent_nickname] int,
                                                     [@parent_rowguid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSset_new_identity_range([@artid] uniqueidentifier, [@next_range_begin] numeric(38),
                                                 [@next_range_end] numeric(38), [@range_begin] numeric(38),
                                                 [@range_end] numeric(38), [@range_type] tinyint,
                                                 [@ranges_given] tinyint,
                                                 [@subid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSset_oledb_prop([@property_name] sysname, [@property_value] bit,
                                         [@provider_name] sysname) as -- missing source code
go

create procedure sys.sp_MSset_snapshot_xact_seqno([@article_id] int, [@publication] sysname, [@publisher_db] sysname,
                                                  [@publisher_id] int, [@publisher_seqno] varbinary(16), [@reset] bit,
                                                  [@ss_cplt_seqno] varbinary(16),
                                                  [@xact_seqno] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSset_sub_guid([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                       [@queue_id] sysname, [@queue_server] sysname, [@subscription_guid] binary(16),
                                       [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MSset_subscription_properties([@allow_subscription_copy] bit, [@attach_version] binary(16),
                                                      [@publication] sysname, [@publisher] sysname,
                                                      [@publisher_db] sysname, [@queue_id] sysname,
                                                      [@queue_server] sysname, [@subscription_type] int,
                                                      [@update_mode] int) as -- missing source code
go

create procedure sys.sp_MSsetaccesslist([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSsetalertinfo([@failsafeemailaddress] nvarchar(255), [@failsafenetsendaddress] nvarchar(255),
                                       [@failsafeoperator] nvarchar(255), [@failsafepageraddress] nvarchar(255),
                                       [@forwardalways] int, [@forwardingserver] nvarchar(255),
                                       [@forwardingseverity] int, [@notificationmethod] int,
                                       [@pagercctemplate] nvarchar(255), [@pagersendsubjectonly] int,
                                       [@pagersubjecttemplate] nvarchar(255),
                                       [@pagertotemplate] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_MSsetartprocs([@article] sysname, [@force_flag] int, [@pubid] uniqueidentifier,
                                      [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSsetbit([@bm] varbinary(128), [@coltoadd] smallint, [@toset] int) as -- missing source code
go

create procedure sys.sp_MSsetconflictscript([@article] sysname, [@conflict_script] nvarchar(255), [@login] sysname,
                                            [@password] nvarchar(524), [@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSsetconflicttable([@article] sysname, [@conflict_table] sysname, [@publication] sysname,
                                           [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSsetcontext_bypasswholeddleventbit([@onoff] bit) as -- missing source code
go

create procedure sys.sp_MSsetcontext_replagent([@agent_type] tinyint, [@is_publisher] bit) as -- missing source code
go

create procedure sys.sp_MSsetgentozero([@metatype] tinyint, [@rowguid] uniqueidentifier, [@tablenick] int) as -- missing source code
go

create procedure sys.sp_MSsetlastrecgen([@repid] uniqueidentifier, [@srcgen] bigint,
                                        [@srcguid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSsetlastsentgen([@repid] uniqueidentifier, [@srcgen] bigint,
                                         [@srcguid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSsetreplicainfo([@activate_subscription] bit, [@compatlevel] int,
                                         [@datasource_path] nvarchar(255), [@datasource_type] int, [@db_name] sysname,
                                         [@partition_id] int, [@publication] sysname, [@publisher] sysname,
                                         [@publisher_db] sysname, [@replica_version] int, [@replnick] varbinary(6),
                                         [@schemaversion] int, [@server_name] sysname,
                                         [@subid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSsetreplicaschemaversion([@schemaguid] uniqueidentifier, [@schemaversion] int,
                                                  [@subid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSsetreplicastatus([@status_value] int, [@subid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSsetrowmetadata([@colv] varbinary(2953), [@compatlevel] int, [@generation] bigint,
                                         [@isinsert] bit, [@lineage] varbinary(311), [@partition_id] int,
                                         [@partition_options] tinyint, [@pubid] uniqueidentifier,
                                         [@publication_number] smallint, [@rowguid] uniqueidentifier, [@tablenick] int,
                                         [@type] tinyint, [@was_tombstone] int) as -- missing source code
go

create procedure sys.sp_MSsetsubscriberinfo([@expr] nvarchar(500), [@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSsettopology([@X] int, [@Y] int, [@server] nvarchar(258)) as -- missing source code
go

create procedure sys.sp_MSsetup_identity_range([@artid] uniqueidentifier, [@next_range_begin] numeric(38),
                                               [@next_range_end] numeric(38), [@pubid] uniqueidentifier,
                                               [@range_begin] numeric(38), [@range_end] numeric(38),
                                               [@range_type] tinyint,
                                               [@ranges_needed] tinyint) as -- missing source code
go

create procedure sys.sp_MSsetup_partition_groups([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSsetup_use_partition_groups([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSsetupbelongs([@articlesoption] int, [@belongsname] sysname, [@commongen] bigint,
                                       [@compatlevel] int, [@enumentirerowmetadata] bit, [@genlist] varchar(8000),
                                       [@handle_null_tables] bit, [@maxgen] bigint, [@mingen] bigint,
                                       [@nicknamelist] varchar(8000), [@notbelongsname] sysname, [@publication] sysname,
                                       [@publisher] sysname, [@publisher_db] sysname, [@skipgenlist] varchar(8000),
                                       [@subissql] int, [@tablenickname] int) as -- missing source code
go

create procedure sys.sp_MSsetupnosyncsubwithlsnatdist([@article] sysname, [@destination_db] sysname,
                                                      [@lsnsource] tinyint, [@next_valid_lsn] binary(10),
                                                      [@nosync_setup_script] nvarchar(max),
                                                      [@originator_db_version] int,
                                                      [@originator_meta_data] nvarchar(max),
                                                      [@originator_publication_id] int, [@publication] sysname,
                                                      [@publisher] sysname, [@publisher_db] sysname,
                                                      [@subscriber] sysname,
                                                      [@subscriptionlsn] binary(10)) as -- missing source code
go

create procedure sys.sp_MSsetupnosyncsubwithlsnatdist_cleanup([@article] sysname, [@artid] int,
                                                              [@destination_db] sysname, [@next_valid_lsn] binary(10),
                                                              [@publication] sysname, [@publisher] sysname,
                                                              [@publisher_db] sysname,
                                                              [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_MSsetupnosyncsubwithlsnatdist_helper([@article] sysname, [@artid] int,
                                                             [@destination_db] sysname, [@lsnsource] int,
                                                             [@next_valid_lsn] binary(10),
                                                             [@nosync_setup_script] nvarchar(max), [@pubid] int,
                                                             [@publication] sysname, [@publisher] sysname,
                                                             [@publisher_db] sysname, [@publisher_db_version] int,
                                                             [@script_txt] nvarchar(max), [@subscriber] sysname,
                                                             [@subscriptionlsn] binary(10)) as -- missing source code
go

create procedure sys.sp_MSstartdistribution_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                  [@subscriber] sysname,
                                                  [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSstartmerge_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                           [@subscriber] sysname, [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSstartsnapshot_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSstopdistribution_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                 [@subscriber] sysname,
                                                 [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSstopmerge_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                          [@subscriber] sysname, [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSstopsnapshot_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSsub_check_identity([@lower_bound_id] int) as -- missing source code
go

create procedure sys.sp_MSsub_set_identity([@next_seed] bigint, [@objid] int, [@range] bigint, [@threshold] int) as -- missing source code
go

create procedure sys.sp_MSsubscription_status([@agent_id] int) as -- missing source code
go

create procedure sys.sp_MSsubscriptionvalidated([@log_attempt] bit, [@pubid] uniqueidentifier,
                                                [@subid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MStablechecks([@flags] int, [@tablename] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MStablekeys([@colname] nvarchar(258), [@flags] int, [@keyname] nvarchar(517),
                                    [@tablename] nvarchar(776), [@type] int) as -- missing source code
go

create procedure sys.sp_MStablerefs([@direction] nvarchar(20), [@flags] int, [@reftable] nvarchar(517),
                                    [@tablename] nvarchar(517), [@type] nvarchar(20)) as -- missing source code
go

create procedure sys.sp_MStablespace([@id] int, [@name] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_MStestbit([@bm] varbinary(128), [@coltotest] smallint) as -- missing source code
go

create procedure sys.sp_MStran_ddlrepl([@EventData] xml, [@procmapid] int) as -- missing source code
go

create procedure sys.sp_MStran_is_snapshot_required([@last_xact_seqno] varbinary(16), [@publication] sysname,
                                                    [@publisher] sysname, [@publisher_db] sysname,
                                                    [@run_at_distributor] bit, [@subid] varbinary(16),
                                                    [@subscriber] sysname, [@subscriber_db] sysname,
                                                    [@subscription_guid] varbinary(16),
                                                    [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MStrypurgingoldsnapshotdeliveryprogress() as -- missing source code
go

create procedure sys.sp_MSuniquename([@seed] nvarchar(128), [@start] int) as -- missing source code
go

create procedure sys.sp_MSunmarkifneeded([@object] sysname, [@pre_command] int, [@pubid] uniqueidentifier,
                                         [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSunmarkreplinfo([@object] sysname, [@owner] sysname, [@type] smallint) as -- missing source code
go

create procedure sys.sp_MSunmarkschemaobject([@object] sysname, [@owner] sysname) as -- missing source code
go

create procedure sys.sp_MSunregistersubscription([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                 [@subscriber] sysname,
                                                 [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSupdate_agenttype_default([@profile_id] int) as -- missing source code
go

create procedure sys.sp_MSupdate_singlelogicalrecordmetadata([@logical_record_parent_nickname] int,
                                                             [@logical_record_parent_rowguid] uniqueidentifier,
                                                             [@parent_row_inserted] bit,
                                                             [@replnick] binary(6)) as -- missing source code
go

create procedure sys.sp_MSupdate_subscriber_info([@active_end_date] int, [@active_end_time_of_day] int,
                                                 [@active_start_date] int, [@active_start_time_of_day] int,
                                                 [@commit_batch_size] int, [@description] nvarchar(255),
                                                 [@flush_frequency] int, [@frequency_interval] int,
                                                 [@frequency_recurrence_factor] int, [@frequency_relative_interval] int,
                                                 [@frequency_subday] int, [@frequency_subday_interval] int,
                                                 [@frequency_type] int, [@login] sysname, [@password] nvarchar(524),
                                                 [@publisher] sysname, [@retryattempts] int, [@retrydelay] int,
                                                 [@security_mode] int, [@status_batch_size] int, [@subscriber] sysname,
                                                 [@type] tinyint) as -- missing source code
go

create procedure sys.sp_MSupdate_subscriber_schedule([@active_end_date] int, [@active_end_time_of_day] int,
                                                     [@active_start_date] int, [@active_start_time_of_day] int,
                                                     [@agent_type] tinyint, [@frequency_interval] int,
                                                     [@frequency_recurrence_factor] int,
                                                     [@frequency_relative_interval] int, [@frequency_subday] int,
                                                     [@frequency_subday_interval] int, [@frequency_type] int,
                                                     [@publisher] sysname,
                                                     [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_MSupdate_subscriber_tracer_history([@agent_id] int, [@parent_tracer_id] int) as -- missing source code
go

create procedure sys.sp_MSupdate_subscription([@article_id] int, [@destination_db] sysname, [@publisher] sysname,
                                              [@publisher_db] sysname, [@status] int, [@subscriber] sysname,
                                              [@subscription_seqno] varbinary(16)) as -- missing source code
go

create procedure sys.sp_MSupdate_tracer_history([@tracer_id] int) as -- missing source code
go

create procedure sys.sp_MSupdatecachedpeerlsn([@agent_id] int, [@originator] sysname, [@originator_db] sysname,
                                              [@originator_db_version] int, [@originator_lsn] varbinary(16),
                                              [@originator_publication_id] int, [@type] int) as -- missing source code
go

create procedure sys.sp_MSupdategenerations_afterbcp([@pubid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSupdategenhistory([@art_nick] int, [@gen] bigint, [@guidsrc] uniqueidentifier,
                                           [@is_ssce_empty_sync] int, [@partition_id] int, [@pubid] uniqueidentifier,
                                           [@publication_number] smallint) as -- missing source code
go

create procedure sys.sp_MSupdateinitiallightweightsubscription([@allow_subscription_copy] bit,
                                                               [@allow_synctoalternate] bit,
                                                               [@automatic_reinitialization_policy] bit,
                                                               [@conflict_logging] int, [@pubid] uniqueidentifier,
                                                               [@publication_name] sysname, [@publisher] sysname,
                                                               [@publisher_db] sysname, [@replicate_ddl] int,
                                                               [@retention] int,
                                                               [@status] int) as -- missing source code
go

create procedure sys.sp_MSupdatelastsyncinfo([@last_sync_status] int, [@last_sync_summary] sysname,
                                             [@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                             [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_MSupdatepeerlsn([@originator] sysname, [@originator_db] sysname, [@originator_db_version] int,
                                        [@originator_lsn] varbinary(10),
                                        [@originator_publication_id] int) as -- missing source code
go

create procedure sys.sp_MSupdaterecgen([@altrecgen] bigint, [@altrecguid] uniqueidentifier,
                                       [@altrepid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSupdatereplicastate([@pubid] uniqueidentifier, [@replicastate] uniqueidentifier,
                                             [@subid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSupdatesysmergearticles([@artid] uniqueidentifier, [@object] sysname, [@owner] sysname,
                                                 [@pubid] uniqueidentifier,
                                                 [@recreate_repl_view] bit) as -- missing source code
go

create procedure sys.sp_MSuplineageversion([@rowguid] uniqueidentifier, [@tablenick] int, [@version] int) as -- missing source code
go

create procedure sys.sp_MSuploadsupportabilitydata([@compatlevel] int, [@db_name] sysname, [@file_name] nvarchar(2000),
                                                   [@log_file] varbinary(max), [@log_file_type] int,
                                                   [@publication] sysname, [@publisher] sysname,
                                                   [@publisher_db] sysname, [@server_name] sysname,
                                                   [@web_server] sysname) as -- missing source code
go

create procedure sys.sp_MSuselightweightreplication([@lightweight] int, [@publication] sysname, [@publisher] sysname,
                                                    [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_MSvalidate_dest_recgen([@pubid] uniqueidentifier, [@recgen] bigint,
                                               [@recguid] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_MSvalidate_subscription([@artid] int, [@subscriber] sysname, [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_MSvalidate_wellpartitioned_articles([@publication] sysname) as -- missing source code
go

create procedure sys.sp_MSvalidatearticle([@artid] uniqueidentifier, [@expected_checksum] numeric(18),
                                          [@expected_rowcount] bigint, [@full_or_fast] tinyint,
                                          [@pubid] uniqueidentifier, [@validation_type] int) as -- missing source code
go

create procedure sys.sp_MSwritemergeperfcounter([@agent_id] int, [@counter_desc] nvarchar(100), [@counter_value] int,
                                                [@thread_num] int) as -- missing source code
go

create procedure sys.sp_OACreate() as -- missing source code
go

create procedure sys.sp_OADestroy() as -- missing source code
go

create procedure sys.sp_OAGetErrorInfo() as -- missing source code
go

create procedure sys.sp_OAGetProperty() as -- missing source code
go

create procedure sys.sp_OAMethod() as -- missing source code
go

create procedure sys.sp_OASetProperty() as -- missing source code
go

create procedure sys.sp_OAStop() as -- missing source code
go

create procedure sys.sp_ORbitmap([@inputbitmap1] varbinary(128), [@inputbitmap2] varbinary(128),
                                 [@resultbitmap3] varbinary(128)) as -- missing source code
go

create procedure sys.sp_PostAgentInfo() as -- missing source code
go

create procedure sys.sp_SetAutoSAPasswordAndDisable() as -- missing source code
go

create procedure sys.sp_SetOBDCertificate() as -- missing source code
go

create procedure sys.sp_add_agent_parameter([@parameter_name] sysname, [@parameter_value] nvarchar(255),
                                            [@profile_id] int) as -- missing source code
go

create procedure sys.sp_add_agent_profile([@agent_type] int, [@default] bit, [@description] nvarchar(3000),
                                          [@profile_id] int, [@profile_name] sysname,
                                          [@profile_type] int) as -- missing source code
go

create procedure sys.sp_add_columnstore_column_dictionary([@column_id] int, [@table_id] int) as -- missing source code
go

create procedure sys.sp_add_data_file_recover_suspect_db([@dbName] sysname, [@filegroup] nvarchar(260),
                                                         [@filegrowth] nvarchar(20), [@filename] nvarchar(260),
                                                         [@maxsize] nvarchar(20), [@name] nvarchar(260),
                                                         [@size] nvarchar(20)) as -- missing source code
go

create procedure sys.sp_add_log_file_recover_suspect_db([@dbName] sysname, [@filegrowth] nvarchar(20),
                                                        [@filename] nvarchar(260), [@maxsize] nvarchar(20),
                                                        [@name] nvarchar(260),
                                                        [@size] nvarchar(20)) as -- missing source code
go

create procedure sys.sp_add_log_shipping_alert_job([@alert_job_id] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_add_log_shipping_primary_database([@backup_compression] tinyint,
                                                          [@backup_directory] nvarchar(500),
                                                          [@backup_job_id] uniqueidentifier, [@backup_job_name] sysname,
                                                          [@backup_retention_period] int, [@backup_share] nvarchar(500),
                                                          [@backup_threshold] int, [@database] sysname,
                                                          [@history_retention_period] int, [@ignoreremotemonitor] bit,
                                                          [@monitor_server] sysname, [@monitor_server_login] sysname,
                                                          [@monitor_server_password] sysname,
                                                          [@monitor_server_security_mode] bit, [@overwrite] bit,
                                                          [@primary_id] uniqueidentifier, [@threshold_alert] int,
                                                          [@threshold_alert_enabled] bit) as -- missing source code
go

create procedure sys.sp_add_log_shipping_primary_secondary([@overwrite] bit, [@primary_database] sysname,
                                                           [@secondary_database] sysname,
                                                           [@secondary_server] sysname) as -- missing source code
go

create procedure sys.sp_add_log_shipping_secondary_database([@block_size] int, [@buffer_count] int,
                                                            [@disconnect_users] bit, [@history_retention_period] int,
                                                            [@ignoreremotemonitor] bit, [@max_transfer_size] int,
                                                            [@overwrite] bit, [@primary_database] sysname,
                                                            [@primary_server] sysname, [@restore_all] bit,
                                                            [@restore_delay] int, [@restore_mode] bit,
                                                            [@restore_threshold] int, [@secondary_database] sysname,
                                                            [@threshold_alert] int,
                                                            [@threshold_alert_enabled] bit) as -- missing source code
go

create procedure sys.sp_add_log_shipping_secondary_primary([@backup_destination_directory] nvarchar(500),
                                                           [@backup_source_directory] nvarchar(500),
                                                           [@copy_job_id] uniqueidentifier, [@copy_job_name] sysname,
                                                           [@file_retention_period] int, [@ignoreremotemonitor] bit,
                                                           [@monitor_server] sysname, [@monitor_server_login] sysname,
                                                           [@monitor_server_password] sysname,
                                                           [@monitor_server_security_mode] bit, [@overwrite] bit,
                                                           [@primary_database] sysname, [@primary_server] sysname,
                                                           [@restore_job_id] uniqueidentifier,
                                                           [@restore_job_name] sysname,
                                                           [@secondary_id] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_add_trusted_assembly() as -- missing source code
go

create procedure sys.sp_addapprole([@password] sysname, [@rolename] sysname) as -- missing source code
go

create procedure sys.sp_addarticle([@article] sysname, [@artid] int, [@auto_identity_range] nvarchar(5),
                                   [@creation_script] nvarchar(255), [@del_cmd] nvarchar(255),
                                   [@description] nvarchar(255), [@destination_owner] sysname,
                                   [@destination_table] sysname, [@filter] nvarchar(386),
                                   [@filter_clause] nvarchar(max), [@filter_owner] sysname,
                                   [@fire_triggers_on_snapshot] nvarchar(5), [@force_invalidate_snapshot] bit,
                                   [@identity_range] bigint, [@identityrangemanagementoption] nvarchar(10),
                                   [@ins_cmd] nvarchar(255), [@pre_creation_cmd] nvarchar(10),
                                   [@pub_identity_range] bigint, [@publication] sysname, [@publisher] sysname,
                                   [@schema_option] varbinary(8), [@source_object] sysname, [@source_owner] sysname,
                                   [@source_table] nvarchar(386), [@status] tinyint, [@sync_object] nvarchar(386),
                                   [@sync_object_owner] sysname, [@threshold] int, [@type] sysname,
                                   [@upd_cmd] nvarchar(255), [@use_default_datatypes] bit,
                                   [@vertical_partition] nchar(5)) as -- missing source code
go

create procedure sys.sp_adddatatype([@createparams] int, [@dbms] sysname, [@type] sysname,
                                    [@version] sysname) as -- missing source code
go

create procedure sys.sp_adddatatypemapping([@dataloss] bit, [@destination_createparams] int,
                                           [@destination_dbms] sysname, [@destination_length] bigint,
                                           [@destination_nullable] bit, [@destination_precision] bigint,
                                           [@destination_scale] int, [@destination_type] sysname,
                                           [@destination_version] varchar(10), [@is_default] bit,
                                           [@source_dbms] sysname, [@source_length_max] bigint,
                                           [@source_length_min] bigint, [@source_nullable] bit,
                                           [@source_precision_max] bigint, [@source_precision_min] bigint,
                                           [@source_scale_max] int, [@source_scale_min] int, [@source_type] sysname,
                                           [@source_version] varchar(10)) as -- missing source code
go

create procedure sys.sp_adddistpublisher([@distribution_db] sysname, [@encrypted_password] bit, [@login] sysname,
                                         [@password] sysname, [@publisher] sysname, [@publisher_type] sysname,
                                         [@security_mode] int, [@thirdparty_flag] bit, [@trusted] nvarchar(5),
                                         [@working_directory] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_adddistributiondb([@createmode] int, [@data_file] nvarchar(255), [@data_file_size] int,
                                          [@data_folder] nvarchar(255), [@database] sysname, [@deletebatchsize_cmd] int,
                                          [@deletebatchsize_xact] int, [@from_scripting] bit, [@history_retention] int,
                                          [@log_file] nvarchar(255), [@log_file_size] int, [@log_folder] nvarchar(255),
                                          [@login] sysname, [@max_distretention] int, [@min_distretention] int,
                                          [@password] sysname, [@security_mode] int) as -- missing source code
go

create procedure sys.sp_adddistributor([@distributor] sysname, [@from_scripting] bit, [@heartbeat_interval] int,
                                       [@password] sysname) as -- missing source code
go

create procedure sys.sp_adddynamicsnapshot_job([@active_end_date] int, [@active_end_time_of_day] int,
                                               [@active_start_date] int, [@active_start_time_of_day] int,
                                               [@dynamic_snapshot_jobid] uniqueidentifier,
                                               [@dynamic_snapshot_jobname] sysname, [@frequency_interval] int,
                                               [@frequency_recurrence_factor] int, [@frequency_relative_interval] int,
                                               [@frequency_subday] int, [@frequency_subday_interval] int,
                                               [@frequency_type] int, [@host_name] sysname, [@publication] sysname,
                                               [@suser_sname] sysname) as -- missing source code
go

create procedure sys.sp_addextendedproc([@dllname] varchar(255), [@functname] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_addextendedproperty([@level0name] sysname, [@level0type] varchar(128), [@level1name] sysname,
                                            [@level1type] varchar(128), [@level2name] sysname,
                                            [@level2type] varchar(128), [@name] sysname,
                                            [@value] sql_variant) as -- missing source code
go

create procedure sys.sp_addlinkedserver([@catalog] sysname, [@datasrc] nvarchar(4000), [@location] nvarchar(4000),
                                        [@provider] nvarchar(128), [@provstr] nvarchar(4000), [@server] sysname,
                                        [@srvproduct] nvarchar(128)) as -- missing source code
go

create procedure sys.sp_addlinkedsrvlogin([@locallogin] sysname, [@rmtpassword] sysname, [@rmtsrvname] sysname,
                                          [@rmtuser] sysname, [@useself] varchar(8)) as -- missing source code
go

create procedure sys.sp_addlogin([@defdb] sysname, [@deflanguage] sysname, [@encryptopt] varchar(20),
                                 [@loginame] sysname, [@passwd] sysname, [@sid] varbinary(16)) as -- missing source code
go

create procedure sys.sp_addlogreader_agent([@job_login] nvarchar(257), [@job_name] sysname, [@job_password] sysname,
                                           [@publisher] sysname, [@publisher_login] sysname,
                                           [@publisher_password] sysname,
                                           [@publisher_security_mode] smallint) as -- missing source code
go

create procedure sys.sp_addmergealternatepublisher([@alternate_distributor] sysname, [@alternate_publication] sysname,
                                                   [@alternate_publisher] sysname, [@alternate_publisher_db] sysname,
                                                   [@friendly_name] nvarchar(255), [@publication] sysname,
                                                   [@publisher] sysname, [@publisher_db] sysname,
                                                   [@reserved] nvarchar(20)) as -- missing source code
go

create procedure sys.sp_addmergearticle([@allow_interactive_resolver] nvarchar(5), [@article] sysname,
                                        [@article_resolver] nvarchar(255), [@auto_identity_range] nvarchar(5),
                                        [@check_permissions] int, [@column_tracking] nvarchar(10),
                                        [@compensate_for_errors] nvarchar(5), [@creation_script] nvarchar(255),
                                        [@delete_tracking] nvarchar(5), [@description] nvarchar(255),
                                        [@destination_object] sysname, [@destination_owner] sysname,
                                        [@fast_multicol_updateproc] nvarchar(5), [@force_invalidate_snapshot] bit,
                                        [@force_reinit_subscription] bit, [@identity_range] bigint,
                                        [@identityrangemanagementoption] nvarchar(10),
                                        [@logical_record_level_conflict_detection] nvarchar(5),
                                        [@logical_record_level_conflict_resolution] nvarchar(5),
                                        [@partition_options] tinyint, [@pre_creation_cmd] nvarchar(10),
                                        [@processing_order] int, [@pub_identity_range] bigint, [@publication] sysname,
                                        [@published_in_tran_pub] nvarchar(5), [@resolver_info] nvarchar(517),
                                        [@schema_option] varbinary(8), [@source_object] sysname,
                                        [@source_owner] sysname, [@status] nvarchar(10),
                                        [@stream_blob_columns] nvarchar(5), [@subscriber_upload_options] tinyint,
                                        [@subset_filterclause] nvarchar(1000), [@threshold] int, [@type] sysname,
                                        [@verify_resolver_signature] int,
                                        [@vertical_partition] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_addmergefilter([@article] sysname, [@filter_type] tinyint, [@filtername] sysname,
                                       [@force_invalidate_snapshot] bit, [@force_reinit_subscription] bit,
                                       [@join_articlename] sysname, [@join_filterclause] nvarchar(1000),
                                       [@join_unique_key] int, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_addmergelogsettings([@agent_xe] varbinary(max), [@agent_xe_ring_buffer] varbinary(max),
                                            [@custom_script] nvarchar(2000), [@delete_after_upload] int,
                                            [@log_file_name] sysname, [@log_file_path] nvarchar(255),
                                            [@log_file_size] int, [@log_modules] int, [@log_severity] int,
                                            [@message_pattern] nvarchar(2000), [@no_of_log_files] int,
                                            [@publication] sysname, [@sql_xe] varbinary(max), [@subscriber] sysname,
                                            [@subscriber_db] sysname, [@support_options] int, [@upload_interval] int,
                                            [@web_server] sysname) as -- missing source code
go

create procedure sys.sp_addmergepartition([@host_name] sysname, [@publication] sysname, [@suser_sname] sysname) as -- missing source code
go

create procedure sys.sp_addmergepublication([@add_to_active_directory] nvarchar(5), [@allow_anonymous] nvarchar(5),
                                            [@allow_partition_realignment] nvarchar(5), [@allow_pull] nvarchar(5),
                                            [@allow_push] nvarchar(5),
                                            [@allow_subscriber_initiated_snapshot] nvarchar(5),
                                            [@allow_subscription_copy] nvarchar(5),
                                            [@allow_synctoalternate] nvarchar(5),
                                            [@allow_web_synchronization] nvarchar(5),
                                            [@alt_snapshot_folder] nvarchar(255),
                                            [@automatic_reinitialization_policy] bit,
                                            [@centralized_conflicts] nvarchar(5), [@compress_snapshot] nvarchar(5),
                                            [@conflict_logging] nvarchar(15), [@conflict_retention] int,
                                            [@description] nvarchar(255), [@dynamic_filters] nvarchar(5),
                                            [@enabled_for_internet] nvarchar(5), [@ftp_address] sysname,
                                            [@ftp_login] sysname, [@ftp_password] sysname, [@ftp_port] int,
                                            [@ftp_subdirectory] nvarchar(255), [@generation_leveling_threshold] int,
                                            [@keep_partition_changes] nvarchar(5),
                                            [@max_concurrent_dynamic_snapshots] int, [@max_concurrent_merge] int,
                                            [@post_snapshot_script] nvarchar(255), [@pre_snapshot_script] nvarchar(255),
                                            [@publication] sysname, [@publication_compatibility_level] nvarchar(6),
                                            [@replicate_ddl] int, [@retention] int,
                                            [@retention_period_unit] nvarchar(10),
                                            [@snapshot_in_defaultfolder] nvarchar(5), [@sync_mode] nvarchar(10),
                                            [@use_partition_groups] nvarchar(5),
                                            [@validate_subscriber_info] nvarchar(500),
                                            [@web_synchronization_url] nvarchar(500)) as -- missing source code
go

create procedure sys.sp_addmergepullsubscription([@description] nvarchar(255), [@publication] sysname,
                                                 [@publisher] sysname, [@publisher_db] sysname,
                                                 [@subscriber_type] nvarchar(15), [@subscription_priority] real,
                                                 [@sync_type] nvarchar(15)) as -- missing source code
go

create procedure sys.sp_addmergepullsubscription_agent([@active_end_date] int, [@active_end_time_of_day] int,
                                                       [@active_start_date] int, [@active_start_time_of_day] int,
                                                       [@alt_snapshot_folder] nvarchar(255), [@distributor] sysname,
                                                       [@distributor_login] sysname, [@distributor_password] sysname,
                                                       [@distributor_security_mode] int,
                                                       [@dynamic_snapshot_location] nvarchar(260),
                                                       [@enabled_for_syncmgr] nvarchar(5), [@encrypted_password] bit,
                                                       [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                                       [@frequency_relative_interval] int, [@frequency_subday] int,
                                                       [@frequency_subday_interval] int, [@frequency_type] int,
                                                       [@ftp_address] sysname, [@ftp_login] sysname,
                                                       [@ftp_password] sysname, [@ftp_port] int, [@hostname] sysname,
                                                       [@internet_login] sysname, [@internet_password] nvarchar(524),
                                                       [@internet_security_mode] int, [@internet_timeout] int,
                                                       [@internet_url] nvarchar(260), [@job_login] nvarchar(257),
                                                       [@job_name] sysname, [@job_password] sysname,
                                                       [@merge_jobid] binary(16), [@name] sysname,
                                                       [@offloadagent] nvarchar(5), [@offloadserver] sysname,
                                                       [@optional_command_line] nvarchar(255), [@publication] sysname,
                                                       [@publisher] sysname, [@publisher_db] sysname,
                                                       [@publisher_encrypted_password] bit, [@publisher_login] sysname,
                                                       [@publisher_password] sysname, [@publisher_security_mode] int,
                                                       [@reserved] nvarchar(100), [@subscriber] sysname,
                                                       [@subscriber_db] sysname, [@subscriber_login] sysname,
                                                       [@subscriber_password] sysname, [@subscriber_security_mode] int,
                                                       [@use_ftp] nvarchar(5), [@use_interactive_resolver] nvarchar(5),
                                                       [@use_web_sync] bit,
                                                       [@working_directory] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_addmergepushsubscription_agent([@active_end_date] int, [@active_end_time_of_day] int,
                                                       [@active_start_date] int, [@active_start_time_of_day] int,
                                                       [@enabled_for_syncmgr] nvarchar(5), [@frequency_interval] int,
                                                       [@frequency_recurrence_factor] int,
                                                       [@frequency_relative_interval] int, [@frequency_subday] int,
                                                       [@frequency_subday_interval] int, [@frequency_type] int,
                                                       [@job_login] nvarchar(257), [@job_name] sysname,
                                                       [@job_password] sysname, [@publication] sysname,
                                                       [@publisher_login] sysname, [@publisher_password] sysname,
                                                       [@publisher_security_mode] smallint, [@subscriber] sysname,
                                                       [@subscriber_db] sysname, [@subscriber_login] sysname,
                                                       [@subscriber_password] sysname,
                                                       [@subscriber_security_mode] smallint) as -- missing source code
go

create procedure sys.sp_addmergesubscription([@active_end_date] int, [@active_end_time_of_day] int,
                                             [@active_start_date] int, [@active_start_time_of_day] int,
                                             [@description] nvarchar(255), [@enabled_for_syncmgr] nvarchar(5),
                                             [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                             [@frequency_relative_interval] int, [@frequency_subday] int,
                                             [@frequency_subday_interval] int, [@frequency_type] int,
                                             [@hostname] sysname, [@merge_job_name] sysname, [@offloadagent] bit,
                                             [@offloadserver] sysname, [@optional_command_line] nvarchar(4000),
                                             [@publication] sysname, [@subscriber] sysname, [@subscriber_db] sysname,
                                             [@subscriber_type] nvarchar(15), [@subscription_priority] real,
                                             [@subscription_type] nvarchar(15), [@sync_type] nvarchar(15),
                                             [@use_interactive_resolver] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_addmessage([@lang] sysname, [@msgnum] int, [@msgtext] nvarchar(255), [@replace] varchar(7),
                                   [@severity] smallint, [@with_log] varchar(5)) as -- missing source code
go

create procedure sys.sp_addpublication([@add_to_active_directory] nvarchar(10), [@allow_anonymous] nvarchar(5),
                                       [@allow_drop] nvarchar(5), [@allow_dts] nvarchar(5),
                                       [@allow_initialize_from_backup] nvarchar(5),
                                       [@allow_partition_switch] nvarchar(5), [@allow_pull] nvarchar(5),
                                       [@allow_push] nvarchar(5), [@allow_queued_tran] nvarchar(5),
                                       [@allow_subscription_copy] nvarchar(5), [@allow_sync_tran] nvarchar(5),
                                       [@alt_snapshot_folder] nvarchar(255), [@autogen_sync_procs] nvarchar(5),
                                       [@centralized_conflicts] nvarchar(5), [@compress_snapshot] nvarchar(5),
                                       [@conflict_policy] nvarchar(100), [@conflict_retention] int,
                                       [@description] nvarchar(255), [@enabled_for_het_sub] nvarchar(5),
                                       [@enabled_for_internet] nvarchar(5), [@enabled_for_p2p] nvarchar(5),
                                       [@ftp_address] sysname, [@ftp_login] sysname, [@ftp_password] sysname,
                                       [@ftp_port] int, [@ftp_subdirectory] nvarchar(255),
                                       [@immediate_sync] nvarchar(5), [@independent_agent] nvarchar(5),
                                       [@logreader_job_name] sysname, [@p2p_conflictdetection] nvarchar(5),
                                       [@p2p_continue_onconflict] nvarchar(5), [@p2p_originator_id] int,
                                       [@post_snapshot_script] nvarchar(255), [@pre_snapshot_script] nvarchar(255),
                                       [@publication] sysname, [@publish_local_changes_only] nvarchar(5),
                                       [@publisher] sysname, [@qreader_job_name] sysname, [@queue_type] nvarchar(10),
                                       [@repl_freq] nvarchar(10), [@replicate_ddl] int,
                                       [@replicate_partition_switch] nvarchar(5), [@restricted] nvarchar(10),
                                       [@retention] int, [@snapshot_in_defaultfolder] nvarchar(5),
                                       [@status] nvarchar(8), [@sync_method] nvarchar(40),
                                       [@taskid] int) as -- missing source code
go

create procedure sys.sp_addpublication_snapshot([@active_end_date] int, [@active_end_time_of_day] int,
                                                [@active_start_date] int, [@active_start_time_of_day] int,
                                                [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                                [@frequency_relative_interval] int, [@frequency_subday] int,
                                                [@frequency_subday_interval] int, [@frequency_type] int,
                                                [@job_login] nvarchar(257), [@job_password] sysname,
                                                [@publication] sysname, [@publisher] sysname,
                                                [@publisher_login] sysname, [@publisher_password] sysname,
                                                [@publisher_security_mode] int,
                                                [@snapshot_job_name] nvarchar(100)) as -- missing source code
go

create procedure sys.sp_addpullsubscription([@description] nvarchar(100), [@immediate_sync] bit,
                                            [@independent_agent] nvarchar(5), [@publication] sysname,
                                            [@publisher] sysname, [@publisher_db] sysname,
                                            [@subscription_type] nvarchar(9),
                                            [@update_mode] nvarchar(30)) as -- missing source code
go

create procedure sys.sp_addpullsubscription_agent([@active_end_date] int, [@active_end_time_of_day] int,
                                                  [@active_start_date] int, [@active_start_time_of_day] int,
                                                  [@alt_snapshot_folder] nvarchar(255), [@distribution_db] sysname,
                                                  [@distribution_jobid] binary(16), [@distributor] sysname,
                                                  [@distributor_login] sysname, [@distributor_password] sysname,
                                                  [@distributor_security_mode] int,
                                                  [@dts_package_location] nvarchar(12), [@dts_package_name] sysname,
                                                  [@dts_package_password] sysname, [@enabled_for_syncmgr] nvarchar(5),
                                                  [@encrypted_distributor_password] bit, [@frequency_interval] int,
                                                  [@frequency_recurrence_factor] int,
                                                  [@frequency_relative_interval] int, [@frequency_subday] int,
                                                  [@frequency_subday_interval] int, [@frequency_type] int,
                                                  [@ftp_address] sysname, [@ftp_login] sysname, [@ftp_password] sysname,
                                                  [@ftp_port] int, [@job_login] nvarchar(257), [@job_name] sysname,
                                                  [@job_password] sysname, [@offloadagent] nvarchar(5),
                                                  [@offloadserver] sysname, [@optional_command_line] nvarchar(4000),
                                                  [@publication] sysname, [@publication_type] tinyint,
                                                  [@publisher] sysname, [@publisher_db] sysname,
                                                  [@reserved] nvarchar(100), [@subscriber] sysname,
                                                  [@subscriber_db] sysname, [@subscriber_login] sysname,
                                                  [@subscriber_password] sysname, [@subscriber_security_mode] int,
                                                  [@use_ftp] nvarchar(5),
                                                  [@working_directory] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_addpushsubscription_agent([@active_end_date] int, [@active_end_time_of_day] int,
                                                  [@active_start_date] int, [@active_start_time_of_day] int,
                                                  [@distribution_job_name] sysname,
                                                  [@dts_package_location] nvarchar(12), [@dts_package_name] sysname,
                                                  [@dts_package_password] sysname, [@enabled_for_syncmgr] nvarchar(5),
                                                  [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                                  [@frequency_relative_interval] int, [@frequency_subday] int,
                                                  [@frequency_subday_interval] int, [@frequency_type] int,
                                                  [@job_login] nvarchar(257), [@job_name] sysname,
                                                  [@job_password] sysname, [@publication] sysname, [@publisher] sysname,
                                                  [@subscriber] sysname, [@subscriber_catalog] sysname,
                                                  [@subscriber_datasrc] nvarchar(4000), [@subscriber_db] sysname,
                                                  [@subscriber_location] nvarchar(4000), [@subscriber_login] sysname,
                                                  [@subscriber_password] sysname, [@subscriber_provider] sysname,
                                                  [@subscriber_provider_string] nvarchar(4000),
                                                  [@subscriber_security_mode] smallint) as -- missing source code
go

create procedure sys.sp_addqreader_agent([@frompublisher] bit, [@job_login] nvarchar(257), [@job_name] sysname,
                                         [@job_password] sysname) as -- missing source code
go

create procedure sys.sp_addqueued_artinfo([@article] sysname, [@artid] int, [@cft_table] sysname, [@columns] binary(32),
                                          [@dest_table] sysname, [@owner] sysname, [@publication] sysname,
                                          [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_addremotelogin([@loginame] sysname, [@remotename] sysname, [@remoteserver] sysname) as -- missing source code
go

create procedure sys.sp_addrole([@ownername] sysname, [@rolename] sysname) as -- missing source code
go

create procedure sys.sp_addrolemember([@membername] sysname, [@rolename] sysname) as -- missing source code
go

create procedure sys.sp_addscriptexec([@publication] sysname, [@publisher] sysname, [@scriptfile] nvarchar(4000),
                                      [@skiperror] bit) as -- missing source code
go

create procedure sys.sp_addserver([@duplicate_ok] varchar(13), [@local] varchar(10),
                                  [@server] sysname) as -- missing source code
go

create procedure sys.sp_addsrvrolemember([@loginame] sysname, [@rolename] sysname) as -- missing source code
go

create procedure sys.sp_addsubscriber([@active_end_date] int, [@active_end_time_of_day] int, [@active_start_date] int,
                                      [@active_start_time_of_day] int, [@commit_batch_size] int,
                                      [@description] nvarchar(255), [@encrypted_password] bit, [@flush_frequency] int,
                                      [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                      [@frequency_relative_interval] int, [@frequency_subday] int,
                                      [@frequency_subday_interval] int, [@frequency_type] int, [@login] sysname,
                                      [@password] nvarchar(524), [@publisher] sysname, [@security_mode] int,
                                      [@status_batch_size] int, [@subscriber] sysname,
                                      [@type] tinyint) as -- missing source code
go

create procedure sys.sp_addsubscriber_schedule([@active_end_date] int, [@active_end_time_of_day] int,
                                               [@active_start_date] int, [@active_start_time_of_day] int,
                                               [@agent_type] smallint, [@frequency_interval] int,
                                               [@frequency_recurrence_factor] int, [@frequency_relative_interval] int,
                                               [@frequency_subday] int, [@frequency_subday_interval] int,
                                               [@frequency_type] int, [@publisher] sysname,
                                               [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_addsubscription([@active_end_date] int, [@active_end_time_of_day] int, [@active_start_date] int,
                                        [@active_start_time_of_day] int, [@article] sysname,
                                        [@backupdevicename] nvarchar(1000), [@backupdevicetype] nvarchar(20),
                                        [@destination_db] sysname, [@distribution_job_name] sysname,
                                        [@dts_package_location] nvarchar(12), [@dts_package_name] sysname,
                                        [@dts_package_password] sysname, [@enabled_for_syncmgr] nvarchar(5),
                                        [@fileidhint] int, [@frequency_interval] int,
                                        [@frequency_recurrence_factor] int, [@frequency_relative_interval] int,
                                        [@frequency_subday] int, [@frequency_subday_interval] int,
                                        [@frequency_type] int, [@loopback_detection] nvarchar(5),
                                        [@mediapassword] sysname, [@memory_optimized] bit, [@offloadagent] bit,
                                        [@offloadserver] sysname, [@optional_command_line] nvarchar(4000),
                                        [@password] sysname, [@publication] sysname, [@publisher] sysname,
                                        [@reserved] nvarchar(10), [@status] sysname, [@subscriber] sysname,
                                        [@subscriber_type] tinyint, [@subscription_type] nvarchar(4),
                                        [@subscriptionlsn] binary(10), [@subscriptionstreams] tinyint,
                                        [@sync_type] nvarchar(255), [@unload] bit,
                                        [@update_mode] nvarchar(30)) as -- missing source code
go

create procedure sys.sp_addsynctriggers([@cftproc] sysname, [@del_proc] sysname, [@distributor] sysname,
                                        [@dump_cmds] bit, [@filter_clause] nvarchar(4000), [@identity_col] sysname,
                                        [@identity_support] bit, [@independent_agent] bit, [@ins_proc] sysname,
                                        [@primary_key_bitmap] varbinary(4000), [@proc_owner] sysname,
                                        [@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                        [@pubversion] int, [@sub_table] sysname, [@sub_table_owner] sysname,
                                        [@ts_col] sysname, [@upd_proc] sysname) as -- missing source code
go

create procedure sys.sp_addsynctriggerscore([@alter] bit, [@cftproc] sysname, [@del_proc] sysname, [@del_trig] sysname,
                                            [@dump_cmds] bit, [@filter_clause] nvarchar(4000), [@identity_col] sysname,
                                            [@identity_support] bit, [@independent_agent] bit, [@ins_proc] sysname,
                                            [@ins_trig] sysname, [@primary_key_bitmap] varbinary(4000),
                                            [@proc_owner] sysname, [@publication] sysname, [@publisher] sysname,
                                            [@publisher_db] sysname, [@pubversion] int, [@sub_table] sysname,
                                            [@sub_table_owner] sysname, [@ts_col] sysname, [@upd_proc] sysname,
                                            [@upd_trig] sysname) as -- missing source code
go

create procedure sys.sp_addtabletocontents([@filter_clause] nvarchar(4000), [@owner_name] sysname,
                                           [@table_name] sysname) as -- missing source code
go

create procedure sys.sp_addtype([@nulltype] varchar(8), [@owner] sysname, [@phystype] sysname,
                                [@typename] sysname) as -- missing source code
go

create procedure sys.sp_addumpdevice([@cntrltype] smallint, [@devstatus] varchar(40), [@devtype] varchar(20),
                                     [@logicalname] sysname, [@physicalname] nvarchar(260)) as -- missing source code
go

create procedure sys.sp_adduser([@grpname] sysname, [@loginame] sysname, [@name_in_db] sysname) as -- missing source code
go

create procedure sys.sp_adjustpublisheridentityrange([@publication] sysname, [@table_name] sysname, [@table_owner] sysname) as -- missing source code
go

create procedure sys.sp_alter_nt_job_mem_configs() as -- missing source code
go

create procedure sys.sp_altermessage([@message_id] int, [@parameter] sysname,
                                     [@parameter_value] varchar(5)) as -- missing source code
go

create procedure sys.sp_approlepassword([@newpwd] sysname, [@rolename] sysname) as -- missing source code
go

create procedure sys.sp_article_validation([@article] sysname, [@full_or_fast] tinyint, [@publication] sysname,
                                           [@publisher] sysname, [@reserved] int, [@rowcount_only] smallint,
                                           [@shutdown_agent] bit, [@subscription_level] bit) as -- missing source code
go

create procedure sys.sp_articlecolumn([@article] sysname, [@change_active] int, [@column] sysname,
                                      [@force_invalidate_snapshot] bit, [@force_reinit_subscription] bit,
                                      [@ignore_distributor] bit, [@internal] bit, [@operation] nvarchar(5),
                                      [@publication] sysname, [@publisher] sysname,
                                      [@refresh_synctran_procs] bit) as -- missing source code
go

create procedure sys.sp_articlefilter([@article] sysname, [@filter_clause] nvarchar(max), [@filter_name] nvarchar(517),
                                      [@force_invalidate_snapshot] bit, [@force_reinit_subscription] bit,
                                      [@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_articleview([@article] sysname, [@change_active] int, [@filter_clause] nvarchar(max),
                                    [@force_invalidate_snapshot] bit, [@force_reinit_subscription] bit, [@internal] bit,
                                    [@publication] sysname, [@publisher] sysname, [@refreshsynctranprocs] bit,
                                    [@view_name] nvarchar(386)) as -- missing source code
go

create procedure sys.sp_assemblies_rowset([@assembly_id] int, [@assembly_name] sysname,
                                          [@assembly_schema] sysname) as -- missing source code
go

create procedure sys.sp_assemblies_rowset2([@assembly_id] int, [@assembly_schema] sysname) as -- missing source code
go

create procedure sys.sp_assemblies_rowset_rmt([@assembly_id] int, [@assembly_name] sysname, [@assembly_schema] sysname,
                                              [@catalog_name] sysname, [@server_name] sysname) as -- missing source code
go

create procedure sys.sp_assembly_dependencies_rowset([@assembly_id] int, [@assembly_referenced] int,
                                                     [@assembly_schema] sysname) as -- missing source code
go

create procedure sys.sp_assembly_dependencies_rowset2([@assembly_referenced] int, [@assembly_schema] sysname) as -- missing source code
go

create procedure sys.sp_assembly_dependencies_rowset_rmt([@assembly_id] int, [@assembly_referenced] int,
                                                         [@assembly_schema] sysname, [@catalog] sysname,
                                                         [@server] sysname) as -- missing source code
go

create procedure sys.sp_attach_db([@dbname] sysname, [@filename1] nvarchar(260), [@filename10] nvarchar(260),
                                  [@filename11] nvarchar(260), [@filename12] nvarchar(260), [@filename13] nvarchar(260),
                                  [@filename14] nvarchar(260), [@filename15] nvarchar(260), [@filename16] nvarchar(260),
                                  [@filename2] nvarchar(260), [@filename3] nvarchar(260), [@filename4] nvarchar(260),
                                  [@filename5] nvarchar(260), [@filename6] nvarchar(260), [@filename7] nvarchar(260),
                                  [@filename8] nvarchar(260), [@filename9] nvarchar(260)) as -- missing source code
go

create procedure sys.sp_attach_single_file_db([@dbname] sysname, [@physname] nvarchar(260)) as -- missing source code
go

create procedure sys.sp_attachsubscription([@db_master_key_password] nvarchar(524), [@dbname] sysname,
                                           [@distributor_login] sysname, [@distributor_password] sysname,
                                           [@distributor_security_mode] int, [@filename] nvarchar(260),
                                           [@job_login] nvarchar(257), [@job_password] sysname,
                                           [@publisher_login] sysname, [@publisher_password] sysname,
                                           [@publisher_security_mode] int, [@subscriber_login] sysname,
                                           [@subscriber_password] sysname,
                                           [@subscriber_security_mode] int) as -- missing source code
go

create procedure sys.sp_audit_write() as -- missing source code
go

create procedure sys.sp_autostats([@flagc] varchar(10), [@indname] sysname,
                                  [@tblname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_availability_group_command_internal() as -- missing source code
go

create procedure sys.sp_bcp_dbcmptlevel([@dbname] sysname) as -- missing source code
go

create procedure sys.sp_begin_parallel_nested_tran() as -- missing source code
go

create procedure sys.sp_bindefault([@defname] nvarchar(776), [@futureonly] varchar(15),
                                   [@objname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_bindrule([@futureonly] varchar(15), [@objname] nvarchar(776),
                                 [@rulename] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_bindsession() as -- missing source code
go

create procedure sys.sp_browsemergesnapshotfolder([@publication] sysname) as -- missing source code
go

create procedure sys.sp_browsereplcmds([@agent_id] int, [@article_id] int, [@command_id] int,
                                       [@compatibility_level] int, [@originator_id] int, [@publisher_database_id] int,
                                       [@xact_seqno_end] nchar(22),
                                       [@xact_seqno_start] nchar(22)) as -- missing source code
go

create procedure sys.sp_browsesnapshotfolder([@publication] sysname, [@publisher] sysname, [@subscriber] sysname,
                                             [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_can_tlog_be_applied([@backup_file_name] nvarchar(500), [@database_name] sysname, [@result] bit,
                                            [@verbose] bit) as -- missing source code
go

create procedure sys.sp_catalogs([@server_name] sysname) as -- missing source code
go

create procedure sys.sp_catalogs_rowset([@catalog_name] sysname) as -- missing source code
go

create procedure sys.sp_catalogs_rowset2() as -- missing source code
go

create procedure sys.sp_catalogs_rowset_rmt([@catalog_name] sysname, [@server_name] sysname) as -- missing source code
go

create procedure sys.sp_cdc_add_job([@check_for_logreader] bit, [@continuous] bit, [@job_type] nvarchar(20),
                                    [@maxscans] int, [@maxtrans] int, [@pollinginterval] bigint, [@retention] bigint,
                                    [@start_job] bit, [@threshold] bigint) as -- missing source code
go

create procedure sys.sp_cdc_change_job([@continuous] bit, [@job_type] nvarchar(20), [@maxscans] int, [@maxtrans] int,
                                       [@pollinginterval] bigint, [@retention] bigint,
                                       [@threshold] bigint) as -- missing source code
go

create procedure sys.sp_cdc_cleanup_change_table([@capture_instance] sysname, [@low_water_mark] binary(10),
                                                 [@threshold] bigint) as -- missing source code
go

create procedure sys.sp_cdc_dbsnapshotLSN([@db_snapshot] sysname, [@lastLSN] binary(10),
                                          [@lastLSNstr] varchar(40)) as -- missing source code
go

create procedure sys.sp_cdc_disable_db() as -- missing source code
go

create procedure sys.sp_cdc_disable_table([@capture_instance] sysname, [@source_name] sysname,
                                          [@source_schema] sysname) as -- missing source code
go

create procedure sys.sp_cdc_drop_job([@job_type] nvarchar(20)) as -- missing source code
go

create procedure sys.sp_cdc_enable_db() as -- missing source code
go

create procedure sys.sp_cdc_enable_table([@allow_partition_switch] bit, [@capture_instance] sysname,
                                         [@captured_column_list] nvarchar(max), [@filegroup_name] sysname,
                                         [@index_name] sysname, [@role_name] sysname, [@source_name] sysname,
                                         [@source_schema] sysname,
                                         [@supports_net_changes] bit) as -- missing source code
go

create procedure sys.sp_cdc_generate_wrapper_function([@capture_instance] sysname, [@closed_high_end_point] bit,
                                                      [@column_list] nvarchar(max),
                                                      [@update_flag_list] nvarchar(max)) as -- missing source code
go

create procedure sys.sp_cdc_get_captured_columns([@capture_instance] sysname) as -- missing source code
go

create procedure sys.sp_cdc_get_ddl_history([@capture_instance] sysname) as -- missing source code
go

create procedure sys.sp_cdc_help_change_data_capture([@source_name] sysname, [@source_schema] sysname) as -- missing source code
go

create procedure sys.sp_cdc_help_jobs() as -- missing source code
go

create procedure sys.sp_cdc_restoredb([@db_orig] sysname, [@keep_cdc] int, [@srv_orig] sysname) as -- missing source code
go

create procedure sys.sp_cdc_scan([@continuous] tinyint, [@is_from_job] int, [@maxscans] int, [@maxtrans] int,
                                 [@pollinginterval] bigint) as -- missing source code
go

create procedure sys.sp_cdc_start_job([@job_type] nvarchar(20)) as -- missing source code
go

create procedure sys.sp_cdc_stop_job([@job_type] nvarchar(20)) as -- missing source code
go

create procedure sys.sp_cdc_vupgrade() as -- missing source code
go

create procedure sys.sp_cdc_vupgrade_databases() as -- missing source code
go

create procedure sys.sp_certify_removable([@autofix] nvarchar(4), [@dbname] sysname) as -- missing source code
go

create procedure sys.sp_change_agent_parameter([@parameter_name] sysname, [@parameter_value] nvarchar(255),
                                               [@profile_id] int) as -- missing source code
go

create procedure sys.sp_change_agent_profile([@profile_id] int, [@property] sysname, [@value] nvarchar(3000)) as -- missing source code
go

create procedure sys.sp_change_log_shipping_primary_database([@backup_compression] tinyint,
                                                             [@backup_directory] nvarchar(500),
                                                             [@backup_retention_period] int,
                                                             [@backup_share] nvarchar(500), [@backup_threshold] int,
                                                             [@database] sysname, [@history_retention_period] int,
                                                             [@ignoreremotemonitor] bit,
                                                             [@monitor_server_login] sysname,
                                                             [@monitor_server_password] sysname,
                                                             [@monitor_server_security_mode] bit,
                                                             [@threshold_alert] int,
                                                             [@threshold_alert_enabled] bit) as -- missing source code
go

create procedure sys.sp_change_log_shipping_secondary_database([@block_size] int, [@buffer_count] int,
                                                               [@disconnect_users] bit, [@history_retention_period] int,
                                                               [@ignoreremotemonitor] bit, [@max_transfer_size] int,
                                                               [@restore_all] bit, [@restore_delay] int,
                                                               [@restore_mode] bit, [@restore_threshold] int,
                                                               [@secondary_database] sysname, [@threshold_alert] int,
                                                               [@threshold_alert_enabled] bit) as -- missing source code
go

create procedure sys.sp_change_log_shipping_secondary_primary([@backup_destination_directory] nvarchar(500),
                                                              [@backup_source_directory] nvarchar(500),
                                                              [@file_retention_period] int,
                                                              [@monitor_server_login] sysname,
                                                              [@monitor_server_password] sysname,
                                                              [@monitor_server_security_mode] bit,
                                                              [@primary_database] sysname,
                                                              [@primary_server] sysname) as -- missing source code
go

create procedure sys.sp_change_subscription_properties([@property] sysname, [@publication] sysname,
                                                       [@publication_type] int, [@publisher] sysname,
                                                       [@publisher_db] sysname,
                                                       [@value] nvarchar(1000)) as -- missing source code
go

create procedure sys.sp_change_tracking_waitforchanges() as -- missing source code
go

create procedure sys.sp_change_users_login([@Action] varchar(10), [@LoginName] sysname, [@Password] sysname,
                                           [@UserNamePattern] sysname) as -- missing source code
go

create procedure sys.sp_changearticle([@article] sysname, [@force_invalidate_snapshot] bit,
                                      [@force_reinit_subscription] bit, [@property] nvarchar(100),
                                      [@publication] sysname, [@publisher] sysname,
                                      [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_changearticlecolumndatatype([@article] sysname, [@column] sysname, [@length] bigint,
                                                    [@mapping_id] int, [@precision] bigint, [@publication] sysname,
                                                    [@publisher] sysname, [@scale] bigint,
                                                    [@type] sysname) as -- missing source code
go

create procedure sys.sp_changedbowner([@loginame] sysname, [@map] varchar(5)) as -- missing source code
go

create procedure sys.sp_changedistpublisher([@property] sysname, [@publisher] sysname, [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_changedistributiondb([@database] sysname, [@property] sysname, [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_changedistributor_password([@password] sysname) as -- missing source code
go

create procedure sys.sp_changedistributor_property([@property] sysname, [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_changedynamicsnapshot_job([@active_end_date] int, [@active_end_time_of_day] int,
                                                  [@active_start_date] int, [@active_start_time_of_day] int,
                                                  [@dynamic_snapshot_jobid] uniqueidentifier,
                                                  [@dynamic_snapshot_jobname] sysname, [@frequency_interval] int,
                                                  [@frequency_recurrence_factor] int,
                                                  [@frequency_relative_interval] int, [@frequency_subday] int,
                                                  [@frequency_subday_interval] int, [@frequency_type] int,
                                                  [@job_login] nvarchar(257), [@job_password] sysname,
                                                  [@publication] sysname) as -- missing source code
go

create procedure sys.sp_changelogreader_agent([@job_login] nvarchar(257), [@job_password] sysname, [@publisher] sysname,
                                              [@publisher_login] sysname, [@publisher_password] sysname,
                                              [@publisher_security_mode] smallint) as -- missing source code
go

create procedure sys.sp_changemergearticle([@article] sysname, [@force_invalidate_snapshot] bit,
                                           [@force_reinit_subscription] bit, [@property] sysname,
                                           [@publication] sysname, [@value] nvarchar(2000)) as -- missing source code
go

create procedure sys.sp_changemergefilter([@article] sysname, [@filtername] sysname, [@force_invalidate_snapshot] bit,
                                          [@force_reinit_subscription] bit, [@property] sysname, [@publication] sysname,
                                          [@value] nvarchar(1000)) as -- missing source code
go

create procedure sys.sp_changemergelogsettings([@agent_xe] varbinary(max), [@agent_xe_ring_buffer] varbinary(max),
                                               [@custom_script] nvarchar(2000), [@delete_after_upload] int,
                                               [@log_file_name] sysname, [@log_file_path] nvarchar(255),
                                               [@log_file_size] int, [@log_modules] int, [@log_severity] int,
                                               [@message_pattern] nvarchar(2000), [@no_of_log_files] int,
                                               [@publication] sysname, [@sql_xe] varbinary(max), [@subscriber] sysname,
                                               [@subscriber_db] sysname, [@support_options] int, [@upload_interval] int,
                                               [@web_server] sysname) as -- missing source code
go

create procedure sys.sp_changemergepublication([@force_invalidate_snapshot] bit, [@force_reinit_subscription] bit,
                                               [@property] sysname, [@publication] sysname,
                                               [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_changemergepullsubscription([@property] sysname, [@publication] sysname, [@publisher] sysname,
                                                    [@publisher_db] sysname,
                                                    [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_changemergesubscription([@force_reinit_subscription] bit, [@property] sysname,
                                                [@publication] sysname, [@subscriber] sysname, [@subscriber_db] sysname,
                                                [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_changeobjectowner([@newowner] sysname, [@objname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_changepublication([@force_invalidate_snapshot] bit, [@force_reinit_subscription] bit,
                                          [@property] nvarchar(255), [@publication] sysname, [@publisher] sysname,
                                          [@value] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_changepublication_snapshot([@active_end_date] int, [@active_end_time_of_day] int,
                                                   [@active_start_date] int, [@active_start_time_of_day] int,
                                                   [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                                   [@frequency_relative_interval] int, [@frequency_subday] int,
                                                   [@frequency_subday_interval] int, [@frequency_type] int,
                                                   [@job_login] nvarchar(257), [@job_password] sysname,
                                                   [@publication] sysname, [@publisher] sysname,
                                                   [@publisher_login] sysname, [@publisher_password] sysname,
                                                   [@publisher_security_mode] int,
                                                   [@snapshot_job_name] nvarchar(100)) as -- missing source code
go

create procedure sys.sp_changeqreader_agent([@frompublisher] bit, [@job_login] nvarchar(257),
                                            [@job_password] sysname) as -- missing source code
go

create procedure sys.sp_changereplicationserverpasswords([@login] nvarchar(257), [@login_type] tinyint,
                                                         [@password] sysname,
                                                         [@server] sysname) as -- missing source code
go

create procedure sys.sp_changesubscriber([@active_end_date] int, [@active_end_time_of_day] int,
                                         [@active_start_date] int, [@active_start_time_of_day] int,
                                         [@commit_batch_size] int, [@description] nvarchar(255), [@flush_frequency] int,
                                         [@frequency_interval] int, [@frequency_recurrence_factor] int,
                                         [@frequency_relative_interval] int, [@frequency_subday] int,
                                         [@frequency_subday_interval] int, [@frequency_type] int, [@login] sysname,
                                         [@password] sysname, [@publisher] sysname, [@security_mode] int,
                                         [@status_batch_size] int, [@subscriber] sysname,
                                         [@type] tinyint) as -- missing source code
go

create procedure sys.sp_changesubscriber_schedule([@active_end_date] int, [@active_end_time_of_day] int,
                                                  [@active_start_date] int, [@active_start_time_of_day] int,
                                                  [@agent_type] smallint, [@frequency_interval] int,
                                                  [@frequency_recurrence_factor] int,
                                                  [@frequency_relative_interval] int, [@frequency_subday] int,
                                                  [@frequency_subday_interval] int, [@frequency_type] int,
                                                  [@publisher] sysname, [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_changesubscription([@article] sysname, [@destination_db] sysname, [@property] nvarchar(30),
                                           [@publication] sysname, [@publisher] sysname, [@subscriber] sysname,
                                           [@value] nvarchar(4000)) as -- missing source code
go

create procedure sys.sp_changesubscriptiondtsinfo([@dts_package_location] nvarchar(12), [@dts_package_name] sysname,
                                                  [@dts_package_password] sysname,
                                                  [@job_id] varbinary(16)) as -- missing source code
go

create procedure sys.sp_changesubstatus([@active_end_date] int, [@active_end_time_of_day] int, [@active_start_date] int,
                                        [@active_start_time_of_day] int, [@article] sysname, [@destination_db] sysname,
                                        [@distribution_job_name] sysname, [@distribution_jobid] binary(16),
                                        [@dts_package_location] int, [@dts_package_name] sysname,
                                        [@dts_package_password] nvarchar(524), [@frequency_interval] int,
                                        [@frequency_recurrence_factor] int, [@frequency_relative_interval] int,
                                        [@frequency_subday] int, [@frequency_subday_interval] int,
                                        [@frequency_type] int, [@from_auto_sync] bit, [@ignore_distributor] bit,
                                        [@ignore_distributor_failure] bit, [@offloadagent] bit,
                                        [@offloadserver] sysname, [@optional_command_line] nvarchar(4000),
                                        [@previous_status] sysname, [@publication] sysname, [@publisher] sysname,
                                        [@skipobjectactivation] int, [@status] sysname,
                                        [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_checkOraclepackageversion([@packageversion] nvarchar(256), [@publisher] sysname,
                                                  [@versionsmatch] int) as -- missing source code
go

create procedure sys.sp_check_constbytable_rowset([@constraint_name] sysname, [@constraint_schema] sysname,
                                                  [@table_name] sysname,
                                                  [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_check_constbytable_rowset2([@constraint_name] sysname, [@constraint_schema] sysname,
                                                   [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_check_constraints_rowset([@constraint_name] sysname, [@constraint_schema] sysname) as -- missing source code
go

create procedure sys.sp_check_constraints_rowset2([@constraint_schema] sysname) as -- missing source code
go

create procedure sys.sp_check_dynamic_filters([@publication] sysname) as -- missing source code
go

create procedure sys.sp_check_for_sync_trigger([@fonpublisher] bit, [@tabid] int, [@trigger_op] char(10)) as -- missing source code
go

create procedure sys.sp_check_join_filter([@filtered_table] nvarchar(400), [@join_filterclause] nvarchar(1000),
                                          [@join_table] nvarchar(400)) as -- missing source code
go

create procedure sys.sp_check_log_shipping_monitor_alert() as -- missing source code
go

create procedure sys.sp_check_publication_access([@given_login] sysname, [@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_check_removable([@autofix] varchar(4)) as -- missing source code
go

create procedure sys.sp_check_subset_filter([@dynamic_filters_function_list] nvarchar(500),
                                            [@filtered_table] nvarchar(400), [@has_dynamic_filters] bit,
                                            [@subset_filterclause] nvarchar(1000)) as -- missing source code
go

create procedure sys.sp_check_sync_trigger([@owner] sysname, [@trigger_op] char(10), [@trigger_procid] int) as -- missing source code
go

create procedure sys.sp_checkinvalidivarticle([@mode] tinyint, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_clean_db_file_free_space([@cleaning_delay] int, [@dbname] sysname, [@fileid] int) as -- missing source code
go

create procedure sys.sp_clean_db_free_space([@cleaning_delay] int, [@dbname] sysname) as -- missing source code
go

create procedure sys.sp_cleanmergelogfiles([@id] int, [@publication] sysname, [@publisher] sysname,
                                           [@publisher_db] sysname, [@subscriber] sysname, [@subscriber_db] sysname,
                                           [@web_server] sysname) as -- missing source code
go

create procedure sys.sp_cleanup_log_shipping_history([@agent_id] uniqueidentifier, [@agent_type] tinyint) as -- missing source code
go

create procedure sys.sp_cleanup_temporal_history([@rowcount] int, [@schema_name] sysname, [@table_name] sysname) as -- missing source code
go

create procedure sys.sp_cleanupdbreplication() as -- missing source code
go

create procedure sys.sp_column_privileges([@column_name] nvarchar(384), [@table_name] sysname, [@table_owner] sysname,
                                          [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_column_privileges_ex([@column_name] sysname, [@table_catalog] sysname, [@table_name] sysname,
                                             [@table_schema] sysname, [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_column_privileges_rowset([@column_name] sysname, [@grantee] sysname, [@grantor] sysname,
                                                 [@table_name] sysname,
                                                 [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_column_privileges_rowset2([@column_name] sysname, [@grantee] sysname, [@grantor] sysname,
                                                  [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_column_privileges_rowset_rmt([@column_name] sysname, [@grantee] sysname, [@grantor] sysname,
                                                     [@table_catalog] sysname, [@table_name] sysname,
                                                     [@table_schema] sysname,
                                                     [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_columns([@ODBCVer] int, [@column_name] nvarchar(384), [@table_name] nvarchar(384),
                                [@table_owner] nvarchar(384), [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_columns_100([@NameScope] int, [@ODBCVer] int, [@column_name] nvarchar(384), [@fUsePattern] bit,
                                    [@table_name] nvarchar(384), [@table_owner] nvarchar(384),
                                    [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_columns_100_rowset([@column_name] sysname, [@table_name] sysname,
                                           [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_columns_100_rowset2([@column_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_columns_90([@ODBCVer] int, [@column_name] nvarchar(384), [@fUsePattern] bit,
                                   [@table_name] nvarchar(384), [@table_owner] nvarchar(384),
                                   [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_columns_90_rowset([@column_name] sysname, [@table_name] sysname,
                                          [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_columns_90_rowset2([@column_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_columns_90_rowset_rmt([@column_name] sysname, [@table_catalog] sysname, [@table_name] sysname,
                                              [@table_schema] sysname,
                                              [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_columns_ex([@ODBCVer] int, [@column_name] sysname, [@table_catalog] sysname,
                                   [@table_name] sysname, [@table_schema] sysname,
                                   [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_columns_ex_100([@ODBCVer] int, [@column_name] sysname, [@fUsePattern] bit,
                                       [@table_catalog] sysname, [@table_name] sysname, [@table_schema] sysname,
                                       [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_columns_ex_90([@ODBCVer] int, [@column_name] sysname, [@fUsePattern] bit,
                                      [@table_catalog] sysname, [@table_name] sysname, [@table_schema] sysname,
                                      [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_columns_managed([@Catalog] sysname, [@Column] sysname, [@Owner] sysname, [@SchemaType] sysname,
                                        [@Table] sysname) as -- missing source code
go

create procedure sys.sp_columns_rowset([@column_name] sysname, [@table_name] sysname,
                                       [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_columns_rowset2([@column_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_columns_rowset_rmt([@column_name] sysname, [@table_catalog] sysname, [@table_name] sysname,
                                           [@table_schema] sysname, [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_commit_parallel_nested_tran() as -- missing source code
go

create procedure sys.sp_configure([@configname] varchar(35), [@configvalue] int) as -- missing source code
go

create procedure sys.sp_configure_peerconflictdetection([@action] nvarchar(32), [@conflict_retention] int,
                                                        [@continue_onconflict] nvarchar(5), [@local] nvarchar(5),
                                                        [@originator_id] int, [@publication] sysname,
                                                        [@timeout] int) as -- missing source code
go

create procedure sys.sp_constr_col_usage_rowset([@column_name] sysname, [@constr_catalog] sysname,
                                                [@constr_name] sysname, [@constr_schema] sysname, [@table_name] sysname,
                                                [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_constr_col_usage_rowset2([@column_name] sysname, [@constr_catalog] sysname,
                                                 [@constr_name] sysname, [@constr_schema] sysname,
                                                 [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_control_dbmasterkey_password() as -- missing source code
go

create procedure sys.sp_control_plan_guide([@name] sysname, [@operation] nvarchar(60)) as -- missing source code
go

create procedure sys.sp_copymergesnapshot([@destination_folder] nvarchar(255), [@publication] sysname) as -- missing source code
go

create procedure sys.sp_copysnapshot([@destination_folder] nvarchar(255), [@publication] sysname, [@publisher] sysname,
                                     [@subscriber] sysname, [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_copysubscription([@filename] nvarchar(260), [@overwrite_existing_file] bit,
                                         [@temp_dir] nvarchar(260)) as -- missing source code
go

create procedure sys.sp_create_plan_guide([@hints] nvarchar(max), [@module_or_batch] nvarchar(max), [@name] sysname,
                                          [@params] nvarchar(max), [@stmt] nvarchar(max),
                                          [@type] nvarchar(60)) as -- missing source code
go

create procedure sys.sp_create_plan_guide_from_handle([@name] sysname, [@plan_handle] varbinary(64),
                                                      [@statement_start_offset] int) as -- missing source code
go

create procedure sys.sp_create_removable([@datalogical1] sysname, [@datalogical10] sysname, [@datalogical11] sysname,
                                         [@datalogical12] sysname, [@datalogical13] sysname, [@datalogical14] sysname,
                                         [@datalogical15] sysname, [@datalogical16] sysname, [@datalogical2] sysname,
                                         [@datalogical3] sysname, [@datalogical4] sysname, [@datalogical5] sysname,
                                         [@datalogical6] sysname, [@datalogical7] sysname, [@datalogical8] sysname,
                                         [@datalogical9] sysname, [@dataphysical1] nvarchar(260),
                                         [@dataphysical10] nvarchar(260), [@dataphysical11] nvarchar(260),
                                         [@dataphysical12] nvarchar(260), [@dataphysical13] nvarchar(260),
                                         [@dataphysical14] nvarchar(260), [@dataphysical15] nvarchar(260),
                                         [@dataphysical16] nvarchar(260), [@dataphysical2] nvarchar(260),
                                         [@dataphysical3] nvarchar(260), [@dataphysical4] nvarchar(260),
                                         [@dataphysical5] nvarchar(260), [@dataphysical6] nvarchar(260),
                                         [@dataphysical7] nvarchar(260), [@dataphysical8] nvarchar(260),
                                         [@dataphysical9] nvarchar(260), [@datasize1] int, [@datasize10] int,
                                         [@datasize11] int, [@datasize12] int, [@datasize13] int, [@datasize14] int,
                                         [@datasize15] int, [@datasize16] int, [@datasize2] int, [@datasize3] int,
                                         [@datasize4] int, [@datasize5] int, [@datasize6] int, [@datasize7] int,
                                         [@datasize8] int, [@datasize9] int, [@dbname] sysname, [@loglogical] sysname,
                                         [@logphysical] nvarchar(260), [@logsize] int, [@syslogical] sysname,
                                         [@sysphysical] nvarchar(260), [@syssize] int) as -- missing source code
go

create procedure sys.sp_createmergepalrole([@publication] sysname) as -- missing source code
go

create procedure sys.sp_createorphan() as -- missing source code
go

create procedure sys.sp_createstats([@fullscan] char(9), [@incremental] char(12), [@indexonly] char(9),
                                    [@norecompute] char(12)) as -- missing source code
go

create procedure sys.sp_createtranpalrole([@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_cursor() as -- missing source code
go

create procedure sys.sp_cursor_list([@cursor_scope] int) returns int as -- missing source code
go

create procedure sys.sp_cursorclose() as -- missing source code
go

create procedure sys.sp_cursorexecute() as -- missing source code
go

create procedure sys.sp_cursorfetch() as -- missing source code
go

create procedure sys.sp_cursoropen() as -- missing source code
go

create procedure sys.sp_cursoroption() as -- missing source code
go

create procedure sys.sp_cursorprepare() as -- missing source code
go

create procedure sys.sp_cursorprepexec() as -- missing source code
go

create procedure sys.sp_cursorunprepare() as -- missing source code
go

create procedure sys.sp_cycle_errorlog() as -- missing source code
go

create procedure sys.sp_databases() as -- missing source code
go

create procedure sys.sp_datatype_info([@ODBCVer] tinyint, [@data_type] int) as -- missing source code
go

create procedure sys.sp_datatype_info_100([@ODBCVer] tinyint, [@data_type] int) as -- missing source code
go

create procedure sys.sp_datatype_info_90([@ODBCVer] tinyint, [@data_type] int) as -- missing source code
go

create procedure sys.sp_db_ebcdic277_2([@dbname] sysname, [@status] varchar(6)) as -- missing source code
go

create procedure sys.sp_db_increased_partitions([@dbname] sysname, [@increased_partitions] varchar(6)) as -- missing source code
go

create procedure sys.sp_db_selective_xml_index([@dbname] sysname, [@selective_xml_index] varchar(6)) as -- missing source code
go

create procedure sys.sp_db_vardecimal_storage_format([@dbname] sysname, [@vardecimal_storage_format] varchar(3)) as -- missing source code
go

create procedure sys.sp_dbcmptlevel([@dbname] sysname, [@new_cmptlevel] tinyint) as -- missing source code
go

create procedure sys.sp_dbfixedrolepermission([@rolename] sysname) as -- missing source code
go

create procedure sys.sp_dbmmonitoraddmonitoring([@update_period] int) as -- missing source code
go

create procedure sys.sp_dbmmonitorchangealert([@alert_id] int, [@database_name] sysname, [@enabled] bit,
                                              [@threshold] int) as -- missing source code
go

create procedure sys.sp_dbmmonitorchangemonitoring([@parameter_id] int, [@value] int) as -- missing source code
go

create procedure sys.sp_dbmmonitordropalert([@alert_id] int, [@database_name] sysname) as -- missing source code
go

create procedure sys.sp_dbmmonitordropmonitoring() as -- missing source code
go

create procedure sys.sp_dbmmonitorhelpalert([@alert_id] int, [@database_name] sysname) as -- missing source code
go

create procedure sys.sp_dbmmonitorhelpmonitoring() as -- missing source code
go

create procedure sys.sp_dbmmonitorresults([@database_name] sysname, [@mode] int, [@update_table] int) as -- missing source code
go

create procedure sys.sp_dbmmonitorupdate([@database_name] sysname) as -- missing source code
go

create procedure sys.sp_dbremove([@dbname] sysname, [@dropdev] varchar(10)) as -- missing source code
go

create procedure sys.sp_ddopen([@NameScope] int, [@ODBCVer] int, [@ccopt] int, [@fUsePattern] bit, [@handle] int,
                               [@p1] nvarchar(774), [@p2] nvarchar(774), [@p3] nvarchar(774), [@p4] nvarchar(774),
                               [@p5] nvarchar(774), [@p6] nvarchar(774), [@p7] int, [@procname] sysname, [@rows] int,
                               [@scrollopt] int) as -- missing source code
go

create procedure sys.sp_defaultdb([@defdb] sysname, [@loginame] sysname) as -- missing source code
go

create procedure sys.sp_defaultlanguage([@language] sysname, [@loginame] sysname) as -- missing source code
go

create procedure sys.sp_delete_backup([@backup_url] nvarchar(360), [@database_name] sysname) as -- missing source code
go

create procedure sys.sp_delete_backup_file_snapshot() as -- missing source code
go

create procedure sys.sp_delete_http_namespace_reservation() as -- missing source code
go

create procedure sys.sp_delete_log_shipping_alert_job() as -- missing source code
go

create procedure sys.sp_delete_log_shipping_primary_database([@database] sysname, [@ignoreremotemonitor] bit) as -- missing source code
go

create procedure sys.sp_delete_log_shipping_primary_secondary([@primary_database] sysname,
                                                              [@secondary_database] sysname,
                                                              [@secondary_server] sysname) as -- missing source code
go

create procedure sys.sp_delete_log_shipping_secondary_database([@ignoreremotemonitor] bit, [@secondary_database] sysname) as -- missing source code
go

create procedure sys.sp_delete_log_shipping_secondary_primary([@primary_database] sysname, [@primary_server] sysname) as -- missing source code
go

create procedure sys.sp_deletemergeconflictrow([@conflict_table] sysname, [@drop_table_if_empty] varchar(10),
                                               [@origin_datasource] varchar(255), [@rowguid] uniqueidentifier,
                                               [@source_object] nvarchar(386)) as -- missing source code
go

create procedure sys.sp_deletepeerrequesthistory([@cutoff_date] datetime, [@publication] sysname, [@request_id] int) as -- missing source code
go

create procedure sys.sp_deletetracertokenhistory([@cutoff_date] datetime, [@publication] sysname, [@publisher] sysname,
                                                 [@publisher_db] sysname, [@tracer_id] int) as -- missing source code
go

create procedure sys.sp_denylogin([@loginame] sysname) as -- missing source code
go

create procedure sys.sp_depends([@objname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_describe_cursor([@cursor_identity] nvarchar(128), [@cursor_source] nvarchar(30)) returns int as -- missing source code
go

create procedure sys.sp_describe_cursor_columns([@cursor_identity] nvarchar(128), [@cursor_source] nvarchar(30)) returns int as -- missing source code
go

create procedure sys.sp_describe_cursor_tables([@cursor_identity] nvarchar(128), [@cursor_source] nvarchar(30)) returns int as -- missing source code
go

create procedure sys.sp_describe_first_result_set() as -- missing source code
go

create procedure sys.sp_describe_parameter_encryption() as -- missing source code
go

create procedure sys.sp_describe_undeclared_parameters() as -- missing source code
go

create procedure sys.sp_detach_db([@dbname] sysname, [@keepfulltextindexfile] nvarchar(10),
                                  [@skipchecks] nvarchar(10)) as -- missing source code
go

create procedure sys.sp_disableagentoffload([@agent_type] sysname, [@job_id] varbinary(16),
                                            [@offloadserver] sysname) as -- missing source code
go

create procedure sys.sp_distcounters() as -- missing source code
go

create procedure sys.sp_drop_agent_parameter([@parameter_name] sysname, [@profile_id] int) as -- missing source code
go

create procedure sys.sp_drop_agent_profile([@profile_id] int) as -- missing source code
go

create procedure sys.sp_drop_trusted_assembly() as -- missing source code
go

create procedure sys.sp_dropanonymousagent([@subid] uniqueidentifier, [@type] int) as -- missing source code
go

create procedure sys.sp_dropanonymoussubscription([@agent_id] int, [@type] int) as -- missing source code
go

create procedure sys.sp_dropapprole([@rolename] sysname) as -- missing source code
go

create procedure sys.sp_droparticle([@article] sysname, [@force_invalidate_snapshot] bit, [@from_drop_publication] bit,
                                    [@ignore_distributor] bit, [@publication] sysname,
                                    [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_dropdatatypemapping([@destination_dbms] sysname, [@destination_length] bigint,
                                            [@destination_nullable] bit, [@destination_precision] bigint,
                                            [@destination_scale] int, [@destination_type] sysname,
                                            [@destination_version] sysname, [@mapping_id] int, [@source_dbms] sysname,
                                            [@source_length_max] bigint, [@source_length_min] bigint,
                                            [@source_nullable] bit, [@source_precision_max] bigint,
                                            [@source_precision_min] bigint, [@source_scale_max] int,
                                            [@source_scale_min] int, [@source_type] sysname,
                                            [@source_version] sysname) as -- missing source code
go

create procedure sys.sp_dropdevice([@delfile] varchar(7), [@logicalname] sysname) as -- missing source code
go

create procedure sys.sp_dropdistpublisher([@ignore_distributor] bit, [@no_checks] bit, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_dropdistributiondb([@database] sysname, [@former_ag_secondary] int) as -- missing source code
go

create procedure sys.sp_dropdistributor([@ignore_distributor] bit, [@no_checks] bit) as -- missing source code
go

create procedure sys.sp_dropdynamicsnapshot_job([@dynamic_snapshot_jobid] uniqueidentifier,
                                                [@dynamic_snapshot_jobname] sysname, [@ignore_distributor] bit,
                                                [@publication] sysname) as -- missing source code
go

create procedure sys.sp_dropextendedproc([@functname] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_dropextendedproperty([@level0name] sysname, [@level0type] varchar(128), [@level1name] sysname,
                                             [@level1type] varchar(128), [@level2name] sysname,
                                             [@level2type] varchar(128), [@name] sysname) as -- missing source code
go

create procedure sys.sp_droplinkedsrvlogin([@locallogin] sysname, [@rmtsrvname] sysname) as -- missing source code
go

create procedure sys.sp_droplogin([@loginame] sysname) as -- missing source code
go

create procedure sys.sp_dropmergealternatepublisher([@alternate_publication] sysname, [@alternate_publisher] sysname,
                                                    [@alternate_publisher_db] sysname, [@publication] sysname,
                                                    [@publisher] sysname,
                                                    [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_dropmergearticle([@article] sysname, [@force_invalidate_snapshot] bit,
                                         [@force_reinit_subscription] bit, [@ignore_distributor] bit,
                                         [@ignore_merge_metadata] bit, [@publication] sysname,
                                         [@reserved] bit) as -- missing source code
go

create procedure sys.sp_dropmergefilter([@article] sysname, [@filtername] sysname, [@force_invalidate_snapshot] bit,
                                        [@force_reinit_subscription] bit,
                                        [@publication] sysname) as -- missing source code
go

create procedure sys.sp_dropmergelogsettings([@publication] sysname, [@subscriber] sysname, [@subscriber_db] sysname,
                                             [@web_server] sysname) as -- missing source code
go

create procedure sys.sp_dropmergepartition([@host_name] sysname, [@publication] sysname, [@suser_sname] sysname) as -- missing source code
go

create procedure sys.sp_dropmergepublication([@ignore_distributor] bit, [@ignore_merge_metadata] bit,
                                             [@publication] sysname, [@reserved] bit) as -- missing source code
go

create procedure sys.sp_dropmergepullsubscription([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                  [@reserved] bit) as -- missing source code
go

create procedure sys.sp_dropmergesubscription([@ignore_distributor] bit, [@publication] sysname, [@reserved] bit,
                                              [@subscriber] sysname, [@subscriber_db] sysname,
                                              [@subscription_type] nvarchar(15)) as -- missing source code
go

create procedure sys.sp_dropmessage([@lang] sysname, [@msgnum] int) as -- missing source code
go

create procedure sys.sp_droporphans() as -- missing source code
go

create procedure sys.sp_droppublication([@from_backup] bit, [@ignore_distributor] bit, [@publication] sysname,
                                        [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_droppublisher([@publisher] sysname, [@type] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_droppullsubscription([@from_backup] bit, [@publication] sysname, [@publisher] sysname,
                                             [@publisher_db] sysname, [@reserved] bit) as -- missing source code
go

create procedure sys.sp_dropremotelogin([@loginame] sysname, [@remotename] sysname, [@remoteserver] sysname) as -- missing source code
go

create procedure sys.sp_dropreplsymmetrickey([@check_replication] bit, [@throw_error] bit) as -- missing source code
go

create procedure sys.sp_droprole([@rolename] sysname) as -- missing source code
go

create procedure sys.sp_droprolemember([@membername] sysname, [@rolename] sysname) as -- missing source code
go

create procedure sys.sp_dropserver([@droplogins] char(10), [@server] sysname) as -- missing source code
go

create procedure sys.sp_dropsrvrolemember([@loginame] sysname, [@rolename] sysname) as -- missing source code
go

create procedure sys.sp_dropsubscriber([@ignore_distributor] bit, [@publisher] sysname, [@reserved] nvarchar(50),
                                       [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_dropsubscription([@article] sysname, [@destination_db] sysname, [@ignore_distributor] bit,
                                         [@publication] sysname, [@publisher] sysname, [@reserved] nvarchar(10),
                                         [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_droptype([@typename] sysname) as -- missing source code
go

create procedure sys.sp_dropuser([@name_in_db] sysname) as -- missing source code
go

create procedure sys.sp_dsninfo([@dsn] varchar(128), [@dso_type] int, [@infotype] varchar(128), [@login] varchar(128),
                                [@password] varchar(128)) as -- missing source code
go

create procedure sys.sp_enable_heterogeneous_subscription([@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_enable_sql_debug() as -- missing source code
go

create procedure sys.sp_enableagentoffload([@agent_type] sysname, [@job_id] varbinary(16),
                                           [@offloadserver] sysname) as -- missing source code
go

create procedure sys.sp_enum_oledb_providers() as -- missing source code
go

create procedure sys.sp_enumcustomresolvers([@distributor] sysname) as -- missing source code
go

create procedure sys.sp_enumdsn() as -- missing source code
go

create procedure sys.sp_enumeratependingschemachanges([@publication] sysname, [@starting_schemaversion] int) as -- missing source code
go

create procedure sys.sp_enumerrorlogs([@p1] int) as -- missing source code
go

create procedure sys.sp_enumfullsubscribers([@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_enumoledbdatasources() as -- missing source code
go

create procedure sys.sp_estimate_data_compression_savings([@data_compression] nvarchar(60), [@index_id] int,
                                                          [@object_name] sysname, [@partition_number] int,
                                                          [@schema_name] sysname) as -- missing source code
go

create procedure sys.sp_estimated_rowsize_reduction_for_vardecimal([@table_name] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_execute() as -- missing source code
go

create procedure sys.sp_execute_external_script() as -- missing source code
go

create procedure sys.sp_executesql() as -- missing source code
go

create procedure sys.sp_expired_subscription_cleanup([@publisher] sysname) as -- missing source code
go

create procedure sys.sp_filestream_force_garbage_collection([@dbname] sysname, [@filename] sysname) as -- missing source code
go

create procedure sys.sp_filestream_recalculate_container_size([@dbname] sysname, [@filename] sysname) as -- missing source code
go

create procedure sys.sp_firstonly_bitmap([@inputbitmap1] varbinary(128), [@inputbitmap2] varbinary(128),
                                         [@resultbitmap3] varbinary(128)) as -- missing source code
go

create procedure sys.sp_fkeys([@fktable_name] sysname, [@fktable_owner] sysname, [@fktable_qualifier] sysname,
                              [@pktable_name] sysname, [@pktable_owner] sysname,
                              [@pktable_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_flush_CT_internal_table_on_demand([@DeletedRowCount] bigint, [@TableToClean] sysname) as -- missing source code
go

create procedure sys.sp_flush_commit_table([@cleanup_version] bigint, [@flush_ts] bigint) as -- missing source code
go

create procedure sys.sp_flush_commit_table_on_demand([@cleanup_ts] bigint, [@date_cleanedup] datetime,
                                                     [@deleted_rows] bigint,
                                                     [@numrows] bigint) as -- missing source code
go

create procedure sys.sp_flush_log() as -- missing source code
go

create procedure sys.sp_foreign_keys_rowset([@foreignkey_tab_catalog] sysname, [@foreignkey_tab_name] sysname,
                                            [@foreignkey_tab_schema] sysname, [@pk_table_name] sysname,
                                            [@pk_table_schema] sysname) as -- missing source code
go

create procedure sys.sp_foreign_keys_rowset2([@foreignkey_tab_name] sysname, [@foreignkey_tab_schema] sysname,
                                             [@pk_table_catalog] sysname, [@pk_table_name] sysname,
                                             [@pk_table_schema] sysname) as -- missing source code
go

create procedure sys.sp_foreign_keys_rowset3([@foreignkey_tab_catalog] sysname, [@foreignkey_tab_schema] sysname,
                                             [@pk_table_catalog] sysname,
                                             [@pk_table_schema] sysname) as -- missing source code
go

create procedure sys.sp_foreign_keys_rowset_rmt([@foreignkey_tab_catalog] sysname, [@foreignkey_tab_name] sysname,
                                                [@foreignkey_tab_schema] sysname, [@pk_table_catalog] sysname,
                                                [@pk_table_name] sysname, [@pk_table_schema] sysname,
                                                [@server_name] sysname) as -- missing source code
go

create procedure sys.sp_foreignkeys([@fktab_catalog] sysname, [@fktab_name] sysname, [@fktab_schema] sysname,
                                    [@pktab_catalog] sysname, [@pktab_name] sysname, [@pktab_schema] sysname,
                                    [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_fulltext_catalog([@action] varchar(20), [@ftcat] sysname, [@path] nvarchar(101)) as -- missing source code
go

create procedure sys.sp_fulltext_column([@action] varchar(20), [@colname] sysname, [@language] int,
                                        [@tabname] nvarchar(517), [@type_colname] sysname) as -- missing source code
go

create procedure sys.sp_fulltext_database([@action] varchar(20)) as -- missing source code
go

create procedure sys.sp_fulltext_getdata() as -- missing source code
go

create procedure sys.sp_fulltext_keymappings() as -- missing source code
go

create procedure sys.sp_fulltext_load_thesaurus_file([@lcid] int, [@loadOnlyIfNotLoaded] bit) as -- missing source code
go

create procedure sys.sp_fulltext_pendingchanges() as -- missing source code
go

create procedure sys.sp_fulltext_recycle_crawl_log([@ftcat] sysname) as -- missing source code
go

create procedure sys.sp_fulltext_semantic_register_language_statistics_db([@dbname] sysname) as -- missing source code
go

create procedure sys.sp_fulltext_semantic_unregister_language_statistics_db() as -- missing source code
go

create procedure sys.sp_fulltext_service([@action] nvarchar(100), [@value] sql_variant) as -- missing source code
go

create procedure sys.sp_fulltext_table([@action] varchar(50), [@ftcat] sysname, [@keyname] sysname,
                                       [@tabname] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_generate_agent_parameter([@profile_id] int, [@real_profile_id] int) as -- missing source code
go

create procedure sys.sp_generatefilters([@publication] sysname) as -- missing source code
go

create procedure sys.sp_getProcessorUsage() as -- missing source code
go

create procedure sys.sp_getVolumeFreeSpace([@database_name] sysname, [@file_id] int) as -- missing source code
go

create procedure sys.sp_get_Oracle_publisher_metadata([@database_name] sysname) as -- missing source code
go

create procedure sys.sp_get_database_scoped_credential() as -- missing source code
go

create procedure sys.sp_get_distributor() as -- missing source code
go

create procedure sys.sp_get_job_status_mergesubscription_agent([@agent_name] nvarchar(100), [@publication] sysname,
                                                               [@publisher] sysname,
                                                               [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_get_mergepublishedarticleproperties([@source_object] sysname, [@source_owner] sysname) as -- missing source code
go

create procedure sys.sp_get_query_template() as -- missing source code
go

create procedure sys.sp_get_redirected_publisher([@bypass_publisher_validation] bit, [@original_publisher] sysname,
                                                 [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_getagentparameterlist([@agent_type] int) as -- missing source code
go

create procedure sys.sp_getapplock([@DbPrincipal] sysname, [@LockMode] varchar(32), [@LockOwner] varchar(32),
                                   [@LockTimeout] int, [@Resource] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_getbindtoken() as -- missing source code
go

create procedure sys.sp_getdefaultdatatypemapping([@dataloss] bit, [@destination_dbms] sysname,
                                                  [@destination_length] bigint, [@destination_nullable] bit,
                                                  [@destination_precision] int, [@destination_scale] int,
                                                  [@destination_type] sysname, [@destination_version] varchar(10),
                                                  [@source_dbms] sysname, [@source_length] bigint,
                                                  [@source_nullable] bit, [@source_precision] int, [@source_scale] int,
                                                  [@source_type] sysname,
                                                  [@source_version] varchar(10)) as -- missing source code
go

create procedure sys.sp_getmergedeletetype([@delete_type] int, [@rowguid] uniqueidentifier,
                                           [@source_object] nvarchar(386)) as -- missing source code
go

create procedure sys.sp_getpublisherlink([@connect_string] nvarchar(300), [@islocalpublisher] bit,
                                         [@trigger_id] int) as -- missing source code
go

create procedure sys.sp_getqueuedarticlesynctraninfo([@artid] int, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_getqueuedrows([@owner] sysname, [@tablename] sysname, [@tranid] nvarchar(70)) as -- missing source code
go

create procedure sys.sp_getschemalock() as -- missing source code
go

create procedure sys.sp_getsqlqueueversion([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                           [@version] int) as -- missing source code
go

create procedure sys.sp_getsubscription_status_hsnapshot([@article] sysname, [@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_getsubscriptiondtspackagename([@publication] sysname, [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_gettopologyinfo([@request_id] int) as -- missing source code
go

create procedure sys.sp_grant_publication_access([@login] sysname, [@publication] sysname, [@publisher] sysname,
                                                 [@reserved] nvarchar(10)) as -- missing source code
go

create procedure sys.sp_grantdbaccess([@loginame] sysname, [@name_in_db] sysname) as -- missing source code
go

create procedure sys.sp_grantlogin([@loginame] sysname) as -- missing source code
go

create procedure sys.sp_help([@objname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_help_agent_default([@agent_type] int, [@profile_id] int) as -- missing source code
go

create procedure sys.sp_help_agent_parameter([@profile_id] int) as -- missing source code
go

create procedure sys.sp_help_agent_profile([@agent_type] int, [@profile_id] int) as -- missing source code
go

create procedure sys.sp_help_datatype_mapping([@dbms_name] sysname, [@dbms_version] sysname, [@source_prec] int,
                                              [@sql_type] sysname) as -- missing source code
go

create procedure sys.sp_help_fulltext_catalog_components() as -- missing source code
go

create procedure sys.sp_help_fulltext_catalogs([@fulltext_catalog_name] sysname) as -- missing source code
go

create procedure sys.sp_help_fulltext_catalogs_cursor([@fulltext_catalog_name] sysname) returns int as -- missing source code
go

create procedure sys.sp_help_fulltext_columns([@column_name] sysname, [@table_name] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_help_fulltext_columns_cursor([@column_name] sysname, [@table_name] nvarchar(517)) returns int as -- missing source code
go

create procedure sys.sp_help_fulltext_system_components([@component_type] sysname, [@param] sysname) as -- missing source code
go

create procedure sys.sp_help_fulltext_tables([@fulltext_catalog_name] sysname, [@table_name] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_help_fulltext_tables_cursor([@fulltext_catalog_name] sysname, [@table_name] nvarchar(517)) returns int as -- missing source code
go

create procedure sys.sp_help_log_shipping_alert_job() as -- missing source code
go

create procedure sys.sp_help_log_shipping_monitor([@verbose] bit) as -- missing source code
go

create procedure sys.sp_help_log_shipping_monitor_primary([@primary_database] sysname, [@primary_server] sysname) as -- missing source code
go

create procedure sys.sp_help_log_shipping_monitor_secondary([@secondary_database] sysname, [@secondary_server] sysname) as -- missing source code
go

create procedure sys.sp_help_log_shipping_primary_database([@database] sysname, [@primary_id] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_help_log_shipping_primary_secondary([@primary_database] sysname) as -- missing source code
go

create procedure sys.sp_help_log_shipping_secondary_database([@secondary_database] sysname, [@secondary_id] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_help_log_shipping_secondary_primary([@primary_database] sysname, [@primary_server] sysname) as -- missing source code
go

create procedure sys.sp_help_peerconflictdetection([@publication] sysname, [@timeout] int) as -- missing source code
go

create procedure sys.sp_help_publication_access([@initial_list] bit, [@login] sysname, [@publication] sysname,
                                                [@publisher] sysname, [@return_granted] bit) as -- missing source code
go

create procedure sys.sp_help_spatial_geography_histogram([@colname] sysname, [@resolution] int, [@sample] float,
                                                         [@tabname] sysname) as -- missing source code
go

create procedure sys.sp_help_spatial_geography_index([@indexname] sysname, [@query_sample] geography,
                                                     [@tabname] nvarchar(776),
                                                     [@verboseoutput] tinyint) as -- missing source code
go

create procedure sys.sp_help_spatial_geography_index_xml([@indexname] sysname, [@query_sample] geography,
                                                         [@tabname] nvarchar(776), [@verboseoutput] tinyint,
                                                         [@xml_output] xml) as -- missing source code
go

create procedure sys.sp_help_spatial_geometry_histogram([@colname] sysname, [@resolution] int, [@sample] float,
                                                        [@tabname] sysname, [@xmax] float, [@xmin] float, [@ymax] float,
                                                        [@ymin] float) as -- missing source code
go

create procedure sys.sp_help_spatial_geometry_index([@indexname] sysname, [@query_sample] geometry,
                                                    [@tabname] nvarchar(776),
                                                    [@verboseoutput] tinyint) as -- missing source code
go

create procedure sys.sp_help_spatial_geometry_index_xml([@indexname] sysname, [@query_sample] geometry,
                                                        [@tabname] nvarchar(776), [@verboseoutput] tinyint,
                                                        [@xml_output] xml) as -- missing source code
go

create procedure sys.sp_helpallowmerge_publication() as -- missing source code
go

create procedure sys.sp_helparticle([@article] sysname, [@found] int, [@publication] sysname, [@publisher] sysname,
                                    [@returnfilter] bit) as -- missing source code
go

create procedure sys.sp_helparticlecolumns([@article] sysname, [@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_helparticledts([@article] sysname, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_helpconstraint([@nomsg] varchar(5), [@objname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_helpdatatypemap([@defaults_only] bit, [@destination_dbms] sysname, [@destination_type] sysname,
                                        [@destination_version] varchar(10), [@source_dbms] sysname,
                                        [@source_type] sysname, [@source_version] varchar(10)) as -- missing source code
go

create procedure sys.sp_helpdb([@dbname] sysname) as -- missing source code
go

create procedure sys.sp_helpdbfixedrole([@rolename] sysname) as -- missing source code
go

create procedure sys.sp_helpdevice([@devname] sysname) as -- missing source code
go

create procedure sys.sp_helpdistpublisher([@check_user] bit, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_helpdistributiondb([@database] sysname) as -- missing source code
go

create procedure sys.sp_helpdistributor([@account] nvarchar(255), [@deletebatchsize_cmd] int,
                                        [@deletebatchsize_xact] int, [@directory] nvarchar(255),
                                        [@dist_listener] sysname, [@distrib_cleanupagent] nvarchar(100),
                                        [@distribdb] sysname, [@distributor] sysname,
                                        [@history_cleanupagent] nvarchar(100), [@history_retention] int,
                                        [@local] nvarchar(5), [@max_distretention] int, [@min_distretention] int,
                                        [@publisher] sysname, [@publisher_type] sysname,
                                        [@rpcsrvname] sysname) as -- missing source code
go

create procedure sys.sp_helpdistributor_properties() as -- missing source code
go

create procedure sys.sp_helpdynamicsnapshot_job([@dynamic_snapshot_jobid] uniqueidentifier,
                                                [@dynamic_snapshot_jobname] sysname,
                                                [@publication] sysname) as -- missing source code
go

create procedure sys.sp_helpextendedproc([@funcname] sysname) as -- missing source code
go

create procedure sys.sp_helpfile([@filename] sysname) as -- missing source code
go

create procedure sys.sp_helpfilegroup([@filegroupname] sysname) as -- missing source code
go

create procedure sys.sp_helpindex([@objname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_helplanguage([@language] sysname) as -- missing source code
go

create procedure sys.sp_helplinkedsrvlogin([@locallogin] sysname, [@rmtsrvname] sysname) as -- missing source code
go

create procedure sys.sp_helplogins([@LoginNamePattern] sysname) as -- missing source code
go

create procedure sys.sp_helplogreader_agent([@publisher] sysname) as -- missing source code
go

create procedure sys.sp_helpmergealternatepublisher([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_helpmergearticle([@article] sysname, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_helpmergearticlecolumn([@article] sysname, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_helpmergearticleconflicts([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_helpmergeconflictrows([@conflict_table] sysname, [@logical_record_conflicts] int,
                                              [@publication] sysname, [@publisher] sysname,
                                              [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_helpmergedeleteconflictrows([@logical_record_conflicts] int, [@publication] sysname,
                                                    [@publisher] sysname, [@publisher_db] sysname,
                                                    [@source_object] nvarchar(386)) as -- missing source code
go

create procedure sys.sp_helpmergefilter([@article] sysname, [@filter_type_bm] binary(1), [@filtername] sysname,
                                        [@publication] sysname) as -- missing source code
go

create procedure sys.sp_helpmergelogfiles([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                          [@subscriber] sysname, [@subscriber_db] sysname,
                                          [@web_server] sysname) as -- missing source code
go

create procedure sys.sp_helpmergelogfileswithdata([@id] int, [@publication] sysname, [@publisher] sysname,
                                                  [@publisher_db] sysname, [@subscriber] sysname,
                                                  [@subscriber_db] sysname,
                                                  [@web_server] sysname) as -- missing source code
go

create procedure sys.sp_helpmergelogsettings([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                             [@subscriber] sysname, [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_helpmergepartition([@host_name] sysname, [@publication] sysname, [@suser_sname] sysname) as -- missing source code
go

create procedure sys.sp_helpmergepublication([@found] int, [@publication] sysname, [@publication_id] uniqueidentifier,
                                             [@publisher] sysname, [@publisher_db] sysname,
                                             [@reserved] nvarchar(20)) as -- missing source code
go

create procedure sys.sp_helpmergepullsubscription([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                  [@subscription_type] nvarchar(10)) as -- missing source code
go

create procedure sys.sp_helpmergesubscription([@found] int, [@publication] sysname, [@publisher] sysname,
                                              [@publisher_db] sysname, [@subscriber] sysname, [@subscriber_db] sysname,
                                              [@subscription_type] nvarchar(15)) as -- missing source code
go

create procedure sys.sp_helpntgroup([@ntname] sysname) as -- missing source code
go

create procedure sys.sp_helppeerrequests([@description] nvarchar(4000), [@publication] sysname) as -- missing source code
go

create procedure sys.sp_helppeerresponses([@request_id] int) as -- missing source code
go

create procedure sys.sp_helppublication([@found] int, [@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_helppublication_snapshot([@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_helppublicationsync([@publication] sysname) as -- missing source code
go

create procedure sys.sp_helppullsubscription([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                             [@show_push] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_helpqreader_agent([@frompublisher] bit) as -- missing source code
go

create procedure sys.sp_helpremotelogin([@remotename] sysname, [@remoteserver] sysname) as -- missing source code
go

create procedure sys.sp_helpreplfailovermode([@failover_mode] nvarchar(10), [@failover_mode_id] tinyint,
                                             [@publication] sysname, [@publisher] sysname,
                                             [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_helpreplicationdb([@dbname] sysname, [@type] sysname) as -- missing source code
go

create procedure sys.sp_helpreplicationdboption([@dbname] sysname, [@reserved] bit, [@type] sysname) as -- missing source code
go

create procedure sys.sp_helpreplicationoption([@optname] sysname) as -- missing source code
go

create procedure sys.sp_helprole([@rolename] sysname) as -- missing source code
go

create procedure sys.sp_helprolemember([@rolename] sysname) as -- missing source code
go

create procedure sys.sp_helprotect([@grantorname] sysname, [@name] nvarchar(776), [@permissionarea] varchar(10),
                                   [@username] sysname) as -- missing source code
go

create procedure sys.sp_helpserver([@optname] varchar(35), [@server] sysname,
                                   [@show_topology] varchar(1)) as -- missing source code
go

create procedure sys.sp_helpsort() as -- missing source code
go

create procedure sys.sp_helpsrvrole([@srvrolename] sysname) as -- missing source code
go

create procedure sys.sp_helpsrvrolemember([@srvrolename] sysname) as -- missing source code
go

create procedure sys.sp_helpstats([@objname] nvarchar(776), [@results] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_helpsubscriberinfo([@publisher] sysname, [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_helpsubscription([@article] sysname, [@destination_db] sysname, [@found] int,
                                         [@publication] sysname, [@publisher] sysname,
                                         [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_helpsubscription_properties([@publication] sysname, [@publication_type] int,
                                                    [@publisher] sysname,
                                                    [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_helpsubscriptionerrors([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                               [@subscriber] sysname,
                                               [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_helptext([@columnname] sysname, [@objname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_helptracertokenhistory([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                               [@tracer_id] int) as -- missing source code
go

create procedure sys.sp_helptracertokens([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_helptrigger([@tabname] nvarchar(776), [@triggertype] char(6)) as -- missing source code
go

create procedure sys.sp_helpuser([@name_in_db] sysname) as -- missing source code
go

create procedure sys.sp_helpxactsetjob([@publisher] sysname) as -- missing source code
go

create procedure sys.sp_http_generate_wsdl_complex() as -- missing source code
go

create procedure sys.sp_http_generate_wsdl_defaultcomplexorsimple([@EndpointID] int, [@Host] nvarchar(256),
                                                                  [@IsSSL] bit, [@QueryString] nvarchar(256),
                                                                  [@UserAgent] nvarchar(256)) as -- missing source code
go

create procedure sys.sp_http_generate_wsdl_defaultsimpleorcomplex([@EndpointID] int, [@Host] nvarchar(256),
                                                                  [@IsSSL] bit, [@QueryString] nvarchar(256),
                                                                  [@UserAgent] nvarchar(256)) as -- missing source code
go

create procedure sys.sp_http_generate_wsdl_simple() as -- missing source code
go

create procedure sys.sp_identitycolumnforreplication([@object_id] int, [@value] bit) as -- missing source code
go

create procedure sys.sp_indexcolumns_managed([@Catalog] sysname, [@Column] sysname, [@ConstraintName] sysname,
                                             [@Owner] sysname, [@Table] sysname) as -- missing source code
go

create procedure sys.sp_indexes([@index_name] sysname, [@is_unique] bit, [@table_catalog] sysname,
                                [@table_name] sysname, [@table_schema] sysname,
                                [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_indexes_100_rowset([@index_name] sysname, [@table_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_indexes_100_rowset2([@index_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_indexes_90_rowset([@index_name] sysname, [@table_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_indexes_90_rowset2([@index_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_indexes_90_rowset_rmt([@index_name] sysname, [@table_catalog] sysname, [@table_name] sysname,
                                              [@table_schema] sysname,
                                              [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_indexes_managed([@Catalog] sysname, [@Name] sysname, [@Owner] sysname,
                                        [@Table] sysname) as -- missing source code
go

create procedure sys.sp_indexes_rowset([@index_name] sysname, [@table_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_indexes_rowset2([@index_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_indexes_rowset_rmt([@index_name] sysname, [@table_catalog] sysname, [@table_name] sysname,
                                           [@table_schema] sysname, [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_indexoption([@IndexNamePattern] nvarchar(1035), [@OptionName] varchar(35),
                                    [@OptionValue] varchar(12)) as -- missing source code
go

create procedure sys.sp_invalidate_textptr([@TextPtrValue] varbinary(16)) as -- missing source code
go

create procedure sys.sp_is_columnstore_column_dictionary_enabled([@column_id] int, [@is_enabled] bit, [@table_id] int) as -- missing source code
go

create procedure sys.sp_is_makegeneration_needed([@needed] int, [@wait] int) as -- missing source code
go

create procedure sys.sp_ivindexhasnullcols([@fhasnullcols] bit, [@viewname] sysname) as -- missing source code
go

create procedure sys.sp_kill_filestream_non_transacted_handles([@handle_id] int, [@table_name] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_kill_oldest_transaction_on_secondary([@database_name] sysname, [@kill_all] bit, [@killed_xdests] bigint) as -- missing source code
go

create procedure sys.sp_lightweightmergemetadataretentioncleanup([@num_rowtrack_rows] int) as -- missing source code
go

create procedure sys.sp_link_publication([@distributor] sysname, [@login] sysname, [@password] sysname,
                                         [@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                         [@security_mode] int) as -- missing source code
go

create procedure sys.sp_linkedservers() as -- missing source code
go

create procedure sys.sp_linkedservers_rowset([@srvname] sysname) as -- missing source code
go

create procedure sys.sp_linkedservers_rowset2() as -- missing source code
go

create procedure sys.sp_lock([@spid1] int, [@spid2] int) as -- missing source code
go

create procedure sys.sp_logshippinginstallmetadata() as -- missing source code
go

create procedure sys.sp_lookupcustomresolver([@article_resolver] nvarchar(255), [@dotnet_assembly_name] nvarchar(255),
                                             [@dotnet_class_name] nvarchar(255), [@is_dotnet_assembly] bit,
                                             [@publisher] sysname,
                                             [@resolver_clsid] nvarchar(50)) as -- missing source code
go

create procedure sys.sp_mapdown_bitmap([@bm] varbinary(128), [@mapdownbm] varbinary(128)) as -- missing source code
go

create procedure sys.sp_markpendingschemachange([@publication] sysname, [@schemaversion] int,
                                                [@status] nvarchar(10)) as -- missing source code
go

create procedure sys.sp_marksubscriptionvalidation([@destination_db] sysname, [@publication] sysname,
                                                   [@publisher] sysname,
                                                   [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_memory_optimized_cs_migration([@object_id] int) as -- missing source code
go

create procedure sys.sp_mergearticlecolumn([@article] sysname, [@column] sysname, [@force_invalidate_snapshot] bit,
                                           [@force_reinit_subscription] bit, [@operation] nvarchar(4),
                                           [@publication] sysname,
                                           [@schema_replication] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_mergecleanupmetadata([@publication] sysname, [@reinitialize_subscriber] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_mergedummyupdate([@rowguid] uniqueidentifier, [@source_object] nvarchar(386)) as -- missing source code
go

create procedure sys.sp_mergemetadataretentioncleanup([@aggressive_cleanup_only] bit, [@num_contents_rows] int,
                                                      [@num_genhistory_rows] int,
                                                      [@num_tombstone_rows] int) as -- missing source code
go

create procedure sys.sp_mergesubscription_cleanup([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_mergesubscriptionsummary([@publication] sysname, [@subscriber] sysname,
                                                 [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_migrate_user_to_contained() as -- missing source code
go

create procedure sys.sp_monitor() as -- missing source code
go

create procedure sys.sp_new_parallel_nested_tran_id() as -- missing source code
go

create procedure sys.sp_objectfilegroup([@objid] int) as -- missing source code
go

create procedure sys.sp_oledb_database() as -- missing source code
go

create procedure sys.sp_oledb_defdb() as -- missing source code
go

create procedure sys.sp_oledb_deflang() as -- missing source code
go

create procedure sys.sp_oledb_language() as -- missing source code
go

create procedure sys.sp_oledb_ro_usrname() as -- missing source code
go

create procedure sys.sp_oledbinfo([@infotype] nvarchar(128), [@login] nvarchar(128), [@password] nvarchar(128),
                                  [@server] nvarchar(128)) as -- missing source code
go

create procedure sys.sp_password([@loginame] sysname, [@new] sysname, [@old] sysname) as -- missing source code
go

create procedure sys.sp_peerconflictdetection_tableaug([@artlist] nvarchar(max), [@enabling] bit, [@originator_id] int,
                                                       [@publication] sysname, [@publisher] sysname,
                                                       [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_pkeys([@table_name] sysname, [@table_owner] sysname,
                              [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_polybase_join_group() as -- missing source code
go

create procedure sys.sp_polybase_leave_group() as -- missing source code
go

create procedure sys.sp_posttracertoken([@publication] sysname, [@publisher] sysname, [@tracer_token_id] int) as -- missing source code
go

create procedure sys.sp_prepare() as -- missing source code
go

create procedure sys.sp_prepexec() as -- missing source code
go

create procedure sys.sp_prepexecrpc() as -- missing source code
go

create procedure sys.sp_primary_keys_rowset([@table_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_primary_keys_rowset2([@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_primary_keys_rowset_rmt([@table_catalog] sysname, [@table_name] sysname,
                                                [@table_schema] sysname,
                                                [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_primarykeys([@table_catalog] sysname, [@table_name] sysname, [@table_schema] sysname,
                                    [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_procedure_params_100_managed([@group_number] int, [@parameter_name] sysname,
                                                     [@procedure_name] sysname,
                                                     [@procedure_schema] sysname) as -- missing source code
go

create procedure sys.sp_procedure_params_100_rowset([@group_number] int, [@parameter_name] sysname,
                                                    [@procedure_name] sysname,
                                                    [@procedure_schema] sysname) as -- missing source code
go

create procedure sys.sp_procedure_params_100_rowset2([@parameter_name] sysname, [@procedure_schema] sysname) as -- missing source code
go

create procedure sys.sp_procedure_params_90_rowset([@group_number] int, [@parameter_name] sysname,
                                                   [@procedure_name] sysname,
                                                   [@procedure_schema] sysname) as -- missing source code
go

create procedure sys.sp_procedure_params_90_rowset2([@parameter_name] sysname, [@procedure_schema] sysname) as -- missing source code
go

create procedure sys.sp_procedure_params_managed([@group_number] int, [@parameter_name] sysname,
                                                 [@procedure_name] sysname,
                                                 [@procedure_schema] sysname) as -- missing source code
go

create procedure sys.sp_procedure_params_rowset([@group_number] int, [@parameter_name] sysname,
                                                [@procedure_name] sysname,
                                                [@procedure_schema] sysname) as -- missing source code
go

create procedure sys.sp_procedure_params_rowset2([@parameter_name] sysname, [@procedure_schema] sysname) as -- missing source code
go

create procedure sys.sp_procedures_rowset([@group_number] int, [@procedure_name] sysname,
                                          [@procedure_schema] sysname) as -- missing source code
go

create procedure sys.sp_procedures_rowset2([@procedure_schema] sysname) as -- missing source code
go

create procedure sys.sp_processlogshippingmonitorhistory([@agent_id] uniqueidentifier, [@agent_type] tinyint,
                                                         [@database] sysname, [@log_time] datetime,
                                                         [@log_time_utc] datetime, [@message] nvarchar(4000),
                                                         [@mode] tinyint, [@monitor_server] sysname,
                                                         [@monitor_server_security_mode] bit, [@session_id] int,
                                                         [@session_status] tinyint) as -- missing source code
go

create procedure sys.sp_processlogshippingmonitorprimary([@backup_threshold] int, [@history_retention_period] int,
                                                         [@last_backup_date] datetime, [@last_backup_date_utc] datetime,
                                                         [@last_backup_file] nvarchar(500), [@mode] tinyint,
                                                         [@monitor_server] sysname, [@monitor_server_security_mode] bit,
                                                         [@primary_database] sysname, [@primary_id] uniqueidentifier,
                                                         [@primary_server] sysname, [@threshold_alert] int,
                                                         [@threshold_alert_enabled] bit) as -- missing source code
go

create procedure sys.sp_processlogshippingmonitorsecondary([@history_retention_period] int,
                                                           [@last_copied_date] datetime,
                                                           [@last_copied_date_utc] datetime,
                                                           [@last_copied_file] nvarchar(500),
                                                           [@last_restored_date] datetime,
                                                           [@last_restored_date_utc] datetime,
                                                           [@last_restored_file] nvarchar(500),
                                                           [@last_restored_latency] int, [@mode] tinyint,
                                                           [@monitor_server] sysname,
                                                           [@monitor_server_security_mode] bit,
                                                           [@primary_database] sysname, [@primary_server] sysname,
                                                           [@restore_threshold] int, [@secondary_database] sysname,
                                                           [@secondary_id] uniqueidentifier,
                                                           [@secondary_server] sysname, [@threshold_alert] int,
                                                           [@threshold_alert_enabled] bit) as -- missing source code
go

create procedure sys.sp_processlogshippingretentioncleanup([@agent_id] uniqueidentifier, [@agent_type] tinyint,
                                                           [@curdate_utc] datetime, [@history_retention_period] int,
                                                           [@monitor_server] sysname,
                                                           [@monitor_server_security_mode] bit) as -- missing source code
go

create procedure sys.sp_procoption([@OptionName] varchar(35), [@OptionValue] varchar(12),
                                   [@ProcName] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_prop_oledb_provider([@p1] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_provider_types_100_rowset([@best_match] tinyint, [@data_type] smallint) as -- missing source code
go

create procedure sys.sp_provider_types_90_rowset([@best_match] tinyint, [@data_type] smallint) as -- missing source code
go

create procedure sys.sp_provider_types_rowset([@best_match] tinyint, [@data_type] smallint) as -- missing source code
go

create procedure sys.sp_publication_validation([@full_or_fast] tinyint, [@publication] sysname, [@publisher] sysname,
                                               [@rowcount_only] smallint,
                                               [@shutdown_agent] bit) as -- missing source code
go

create procedure sys.sp_publicationsummary([@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_publishdb([@dbname] sysname, [@value] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_publisherproperty([@propertyname] sysname, [@propertyvalue] sysname,
                                          [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_query_store_consistency_check() as -- missing source code
go

create procedure sys.sp_query_store_flush_db() as -- missing source code
go

create procedure sys.sp_query_store_force_plan() as -- missing source code
go

create procedure sys.sp_query_store_remove_plan() as -- missing source code
go

create procedure sys.sp_query_store_remove_query() as -- missing source code
go

create procedure sys.sp_query_store_reset_exec_stats() as -- missing source code
go

create procedure sys.sp_query_store_unforce_plan() as -- missing source code
go

create procedure sys.sp_query_tuning_ignore_query() as -- missing source code
go

create procedure sys.sp_query_tuning_unignore_query() as -- missing source code
go

create procedure sys.sp_rda_deauthorize_db() as -- missing source code
go

create procedure sys.sp_rda_get_rpo_duration() as -- missing source code
go

create procedure sys.sp_rda_reauthorize_db() as -- missing source code
go

create procedure sys.sp_rda_reconcile_batch() as -- missing source code
go

create procedure sys.sp_rda_reconcile_columns() as -- missing source code
go

create procedure sys.sp_rda_reconcile_indexes() as -- missing source code
go

create procedure sys.sp_rda_set_query_mode() as -- missing source code
go

create procedure sys.sp_rda_set_rpo_duration() as -- missing source code
go

create procedure sys.sp_rda_test_connection() as -- missing source code
go

create procedure sys.sp_readerrorlog([@p1] int, [@p2] int, [@p3] nvarchar(4000), [@p4] nvarchar(4000)) as -- missing source code
go

create procedure sys.sp_recompile([@objname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_redirect_publisher([@original_publisher] sysname, [@publisher_db] sysname,
                                           [@redirected_publisher] sysname) as -- missing source code
go

create procedure sys.sp_refresh_heterogeneous_publisher([@publisher] sysname) as -- missing source code
go

create procedure sys.sp_refresh_log_shipping_monitor([@agent_id] uniqueidentifier, [@agent_type] tinyint,
                                                     [@database] sysname, [@mode] tinyint) as -- missing source code
go

create procedure sys.sp_refresh_parameter_encryption([@name] nvarchar(776), [@namespace] nvarchar(20)) as -- missing source code
go

create procedure sys.sp_refresh_single_snapshot_view([@rgCode] int, [@view_name] nvarchar(261)) as -- missing source code
go

create procedure sys.sp_refresh_snapshot_views([@rgCode] int) as -- missing source code
go

create procedure sys.sp_refreshsqlmodule([@name] nvarchar(776), [@namespace] nvarchar(20)) as -- missing source code
go

create procedure sys.sp_refreshsubscriptions([@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_refreshview([@viewname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_register_custom_scripting([@article] sysname, [@publication] sysname, [@type] varchar(16),
                                                  [@value] nvarchar(2048)) as -- missing source code
go

create procedure sys.sp_registercustomresolver([@article_resolver] nvarchar(255), [@dotnet_assembly_name] nvarchar(255),
                                               [@dotnet_class_name] nvarchar(255), [@is_dotnet_assembly] nvarchar(10),
                                               [@resolver_clsid] nvarchar(50)) as -- missing source code
go

create procedure sys.sp_reinitmergepullsubscription([@publication] sysname, [@publisher] sysname,
                                                    [@publisher_db] sysname,
                                                    [@upload_first] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_reinitmergesubscription([@publication] sysname, [@subscriber] sysname, [@subscriber_db] sysname,
                                                [@upload_first] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_reinitpullsubscription([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_reinitsubscription([@article] sysname, [@destination_db] sysname, [@for_schema_change] bit,
                                           [@ignore_distributor_failure] bit, [@invalidate_snapshot] bit,
                                           [@publication] sysname, [@publisher] sysname,
                                           [@subscriber] sysname) as -- missing source code
go

create procedure sys.sp_releaseapplock([@DbPrincipal] sysname, [@LockOwner] varchar(32),
                                       [@Resource] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_releaseschemalock() as -- missing source code
go

create procedure sys.sp_remote_data_archive_event() as -- missing source code
go

create procedure sys.sp_remoteoption([@loginame] sysname, [@optname] varchar(35), [@optvalue] varchar(10),
                                     [@remotename] sysname, [@remoteserver] sysname) as -- missing source code
go

create procedure sys.sp_remove_columnstore_column_dictionary([@column_id] int, [@table_id] int) as -- missing source code
go

create procedure sys.sp_removedbreplication([@dbname] sysname, [@type] nvarchar(5)) as -- missing source code
go

create procedure sys.sp_removedistpublisherdbreplication([@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_removesrvreplication() as -- missing source code
go

create procedure sys.sp_rename([@newname] sysname, [@objname] nvarchar(1035),
                               [@objtype] varchar(13)) as -- missing source code
go

create procedure sys.sp_renamedb([@dbname] sysname, [@newname] sysname) as -- missing source code
go

create procedure sys.sp_repl_generate_subscriber_event() as -- missing source code
go

create procedure sys.sp_repl_generate_sync_status_event() as -- missing source code
go

create procedure sys.sp_repl_generateevent() as -- missing source code
go

create procedure sys.sp_repladdcolumn([@column] sysname, [@force_invalidate_snapshot] bit,
                                      [@force_reinit_subscription] bit, [@from_agent] int,
                                      [@publication_to_add] nvarchar(4000), [@schema_change_script] nvarchar(4000),
                                      [@source_object] nvarchar(358),
                                      [@typetext] nvarchar(3000)) as -- missing source code
go

create procedure sys.sp_replcleanupccsprocs([@publication] sysname) as -- missing source code
go

create procedure sys.sp_replcmds() as -- missing source code
go

create procedure sys.sp_replcounters() as -- missing source code
go

create procedure sys.sp_replddlparser() as -- missing source code
go

create procedure sys.sp_repldeletequeuedtran([@orderkeyhigh] bigint, [@orderkeylow] bigint, [@publication] sysname,
                                             [@publisher] sysname, [@publisher_db] sysname,
                                             [@tranid] sysname) as -- missing source code
go

create procedure sys.sp_repldone() as -- missing source code
go

create procedure sys.sp_repldropcolumn([@column] sysname, [@force_invalidate_snapshot] bit,
                                       [@force_reinit_subscription] bit, [@from_agent] int,
                                       [@schema_change_script] nvarchar(4000),
                                       [@source_object] nvarchar(270)) as -- missing source code
go

create procedure sys.sp_replflush() as -- missing source code
go

create procedure sys.sp_replgetparsedddlcmd([@FirstToken] sysname, [@dbname] sysname, [@ddlcmd] nvarchar(max),
                                            [@objectType] sysname, [@objname] sysname, [@owner] sysname,
                                            [@targetobject] nvarchar(512)) as -- missing source code
go

create procedure sys.sp_replhelp() as -- missing source code
go

create procedure sys.sp_replica([@replicated] nvarchar(5), [@tabname] nvarchar(92)) as -- missing source code
go

create procedure sys.sp_replication_agent_checkup([@heartbeat_interval] int) as -- missing source code
go

create procedure sys.sp_replicationdboption([@dbname] sysname, [@from_scripting] bit, [@ignore_distributor] bit,
                                            [@optname] sysname, [@value] sysname) as -- missing source code
go

create procedure sys.sp_replincrementlsn([@publisher] sysname, [@xact_seqno] binary(10)) as -- missing source code
go

create procedure sys.sp_replmonitorchangepublicationthreshold([@metric_id] int, [@mode] tinyint, [@publication] sysname,
                                                              [@publication_type] int, [@publisher] sysname,
                                                              [@publisher_db] sysname, [@shouldalert] bit,
                                                              [@thresholdmetricname] sysname,
                                                              [@value] int) as -- missing source code
go

create procedure sys.sp_replmonitorgetoriginalpublisher([@orig_publisher] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_replmonitorhelpmergesession([@agent_name] nvarchar(100), [@hours] int, [@publication] sysname,
                                                    [@publisher] sysname, [@publisher_db] sysname,
                                                    [@session_type] int) as -- missing source code
go

create procedure sys.sp_replmonitorhelpmergesessiondetail([@session_id] int) as -- missing source code
go

create procedure sys.sp_replmonitorhelpmergesubscriptionmoreinfo([@publication] sysname, [@publisher] sysname,
                                                                 [@publisher_db] sysname, [@subscriber] sysname,
                                                                 [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_replmonitorhelppublication([@publication] sysname, [@publication_type] int,
                                                   [@publisher] sysname, [@publisher_db] sysname,
                                                   [@refreshpolicy] tinyint) as -- missing source code
go

create procedure sys.sp_replmonitorhelppublicationthresholds([@publication] sysname, [@publication_type] int,
                                                             [@publisher] sysname, [@publisher_db] sysname,
                                                             [@thresholdmetricname] sysname) as -- missing source code
go

create procedure sys.sp_replmonitorhelppublisher([@publisher] sysname, [@refreshpolicy] tinyint) as -- missing source code
go

create procedure sys.sp_replmonitorhelpsubscription([@exclude_anonymous] bit, [@mode] int, [@publication] sysname,
                                                    [@publication_type] int, [@publisher] sysname,
                                                    [@publisher_db] sysname, [@refreshpolicy] tinyint,
                                                    [@topnum] int) as -- missing source code
go

create procedure sys.sp_replmonitorrefreshjob([@iterations] tinyint, [@profile] bit) as -- missing source code
go

create procedure sys.sp_replmonitorsubscriptionpendingcmds([@publication] sysname, [@publisher] sysname,
                                                           [@publisher_db] sysname, [@subscriber] sysname,
                                                           [@subscriber_db] sysname,
                                                           [@subscription_type] int) as -- missing source code
go

create procedure sys.sp_replpostsyncstatus([@artid] int, [@pubid] int, [@syncstat] int,
                                           [@xact_seqno] binary(10)) as -- missing source code
go

create procedure sys.sp_replqueuemonitor([@publication] sysname, [@publisher] sysname, [@publisherdb] sysname,
                                         [@queuetype] tinyint, [@tranid] sysname) as -- missing source code
go

create procedure sys.sp_replrestart() as -- missing source code
go

create procedure sys.sp_replrethrow() as -- missing source code
go

create procedure sys.sp_replsendtoqueue() as -- missing source code
go

create procedure sys.sp_replsetoriginator([@originator_db] sysname, [@originator_srv] sysname,
                                          [@publication] sysname) as -- missing source code
go

create procedure sys.sp_replsetsyncstatus() as -- missing source code
go

create procedure sys.sp_replshowcmds([@maxtrans] int) as -- missing source code
go

create procedure sys.sp_replsqlqgetrows([@batchsize] int, [@publication] sysname, [@publisher] sysname,
                                        [@publisherdb] sysname) as -- missing source code
go

create procedure sys.sp_replsync([@article] sysname, [@publication] sysname, [@publisher] sysname,
                                 [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_repltrans() as -- missing source code
go

create procedure sys.sp_replwritetovarbin() as -- missing source code
go

create procedure sys.sp_requestpeerresponse([@description] nvarchar(4000), [@publication] sysname,
                                            [@request_id] int) as -- missing source code
go

create procedure sys.sp_requestpeertopologyinfo([@publication] sysname, [@request_id] int) as -- missing source code
go

create procedure sys.sp_reserve_http_namespace() as -- missing source code
go

create procedure sys.sp_reset_connection() as -- missing source code
go

create procedure sys.sp_reset_session_context() as -- missing source code
go

create procedure sys.sp_resetsnapshotdeliveryprogress([@drop_table] nvarchar(5), [@verbose_level] int) as -- missing source code
go

create procedure sys.sp_resetstatus([@DBName] sysname) as -- missing source code
go

create procedure sys.sp_resign_database([@fn] nvarchar(512), [@keytype] sysname, [@pwd] sysname) as -- missing source code
go

create procedure sys.sp_resolve_logins([@dest_db] sysname, [@dest_path] nvarchar(255),
                                       [@filename] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_restore_filelistonly([@backup_path] nvarchar(360), [@device_type] nvarchar(10)) as -- missing source code
go

create procedure sys.sp_restoredbreplication([@db_orig] sysname, [@keep_replication] int, [@perform_upgrade] bit,
                                             [@recoveryforklsn] varbinary(16),
                                             [@srv_orig] sysname) as -- missing source code
go

create procedure sys.sp_restoremergeidentityrange([@article] sysname, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_resyncexecute() as -- missing source code
go

create procedure sys.sp_resyncexecutesql() as -- missing source code
go

create procedure sys.sp_resyncmergesubscription([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                [@resync_date_str] nvarchar(30), [@resync_type] int,
                                                [@subscriber] sysname,
                                                [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_resyncprepare() as -- missing source code
go

create procedure sys.sp_resyncuniquetable() as -- missing source code
go

create procedure sys.sp_revoke_publication_access([@login] sysname, [@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_revokedbaccess([@name_in_db] sysname) as -- missing source code
go

create procedure sys.sp_revokelogin([@loginame] sysname) as -- missing source code
go

create procedure sys.sp_rollback_parallel_nested_tran() as -- missing source code
go

create procedure sys.sp_schemafilter([@operation] nvarchar(4), [@publisher] sysname, [@schema] sysname) as -- missing source code
go

create procedure sys.sp_schemata_rowset([@schema_name] sysname, [@schema_owner] sysname) as -- missing source code
go

create procedure sys.sp_script_reconciliation_delproc([@artid] int, [@publisher] sysname, [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_script_reconciliation_insproc([@artid] int, [@publisher] sysname, [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_script_reconciliation_sinsproc([@artid] int, [@publisher] sysname, [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_script_reconciliation_vdelproc([@artid] int, [@publisher] sysname, [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_script_reconciliation_xdelproc([@artid] int, [@publisher] sysname, [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_script_synctran_commands([@article] sysname, [@publication] sysname, [@trig_only] bit,
                                                 [@usesqlclr] bit) as -- missing source code
go

create procedure sys.sp_scriptdelproc([@artid] int, [@publisher] sysname, [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_scriptdynamicupdproc([@artid] int) as -- missing source code
go

create procedure sys.sp_scriptinsproc([@artid] int, [@publisher] sysname, [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_scriptmappedupdproc([@artid] int, [@mode] tinyint, [@publisher] sysname,
                                            [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_scriptpublicationcustomprocs([@publication] sysname, [@publisher] sysname, [@usesqlclr] bit) as -- missing source code
go

create procedure sys.sp_scriptsinsproc([@artid] int, [@publisher] sysname, [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_scriptsubconflicttable([@alter] bit, [@article] sysname, [@publication] sysname,
                                               [@usesqlclr] bit) as -- missing source code
go

create procedure sys.sp_scriptsupdproc([@artid] int, [@mode] tinyint, [@publisher] sysname,
                                       [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_scriptupdproc([@artid] int, [@mode] tinyint, [@publisher] sysname,
                                      [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_scriptvdelproc([@artid] int, [@publisher] sysname, [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_scriptvupdproc([@artid] int, [@mode] tinyint, [@publisher] sysname,
                                       [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_scriptxdelproc([@artid] int, [@publisher] sysname, [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_scriptxupdproc([@artid] int, [@mode] tinyint, [@publisher] sysname,
                                       [@publishertype] tinyint) as -- missing source code
go

create procedure sys.sp_sequence_get_range([@range_cycle_count] int, [@range_first_value] sql_variant,
                                           [@range_last_value] sql_variant, [@range_size] bigint,
                                           [@sequence_increment] sql_variant, [@sequence_max_value] sql_variant,
                                           [@sequence_min_value] sql_variant,
                                           [@sequence_name] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_server_diagnostics() as -- missing source code
go

create procedure sys.sp_server_info([@attribute_id] int) as -- missing source code
go

create procedure sys.sp_serveroption([@optname] varchar(35), [@optvalue] nvarchar(128),
                                     [@server] sysname) as -- missing source code
go

create procedure sys.sp_setOraclepackageversion([@publisher] sysname) as -- missing source code
go

create procedure sys.sp_set_session_context() as -- missing source code
go

create procedure sys.sp_setapprole([@cookie] varbinary(8000), [@encrypt] varchar(10), [@fCreateCookie] bit,
                                   [@password] sysname, [@rolename] sysname) as -- missing source code
go

create procedure sys.sp_setdefaultdatatypemapping([@destination_dbms] sysname, [@destination_length] bigint,
                                                  [@destination_nullable] bit, [@destination_precision] bigint,
                                                  [@destination_scale] int, [@destination_type] sysname,
                                                  [@destination_version] varchar(10), [@mapping_id] int,
                                                  [@source_dbms] sysname, [@source_length_max] bigint,
                                                  [@source_length_min] bigint, [@source_nullable] bit,
                                                  [@source_precision_max] bigint, [@source_precision_min] bigint,
                                                  [@source_scale_max] int, [@source_scale_min] int,
                                                  [@source_type] sysname,
                                                  [@source_version] varchar(10)) as -- missing source code
go

create procedure sys.sp_setnetname([@netname] sysname, [@server] sysname) as -- missing source code
go

create procedure sys.sp_setreplfailovermode([@failover_mode] nvarchar(10), [@override] tinyint, [@publication] sysname,
                                            [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_setsubscriptionxactseqno([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname,
                                                 [@xact_seqno] varbinary(16)) as -- missing source code
go

create procedure sys.sp_settriggerorder([@namespace] varchar(10), [@order] varchar(10), [@stmttype] varchar(50),
                                        [@triggername] nvarchar(517)) as -- missing source code
go

create procedure sys.sp_setuserbylogin() as -- missing source code
go

create procedure sys.sp_showcolv([@colv] varbinary(2953)) as -- missing source code
go

create procedure sys.sp_showlineage([@lineage] varbinary(311)) as -- missing source code
go

create procedure sys.sp_showmemo_xml() as -- missing source code
go

create procedure sys.sp_showpendingchanges([@article] sysname, [@destination_server] sysname, [@publication] sysname,
                                           [@show_rows] int) as -- missing source code
go

create procedure sys.sp_showrowreplicainfo([@ownername] sysname, [@rowguid] uniqueidentifier, [@show] nvarchar(20),
                                           [@tablename] sysname) as -- missing source code
go

create procedure sys.sp_sm_detach() as -- missing source code
go

create procedure sys.sp_spaceused([@include_total_xtp_storage] bit, [@mode] varchar(11), [@objname] nvarchar(776),
                                  [@oneresultset] bit, [@updateusage] varchar(5)) as -- missing source code
go

create procedure sys.sp_spaceused_remote_data_archive() as -- missing source code
go

create procedure sys.sp_sparse_columns_100_rowset([@column_name] sysname, [@schema_type] int, [@table_name] sysname,
                                                  [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_special_columns([@ODBCVer] int, [@col_type] char, [@nullable] char, [@scope] char,
                                        [@table_name] sysname, [@table_owner] sysname,
                                        [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_special_columns_100([@ODBCVer] int, [@col_type] char, [@nullable] char, [@scope] char,
                                            [@table_name] sysname, [@table_owner] sysname,
                                            [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_special_columns_90([@ODBCVer] int, [@col_type] char, [@nullable] char, [@scope] char,
                                           [@table_name] sysname, [@table_owner] sysname,
                                           [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_sproc_columns([@ODBCVer] int, [@column_name] nvarchar(384), [@fUsePattern] bit,
                                      [@procedure_name] nvarchar(390), [@procedure_owner] nvarchar(384),
                                      [@procedure_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_sproc_columns_100([@ODBCVer] int, [@column_name] nvarchar(384), [@fUsePattern] bit,
                                          [@procedure_name] nvarchar(390), [@procedure_owner] nvarchar(384),
                                          [@procedure_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_sproc_columns_90([@ODBCVer] int, [@column_name] nvarchar(384), [@fUsePattern] bit,
                                         [@procedure_name] nvarchar(390), [@procedure_owner] nvarchar(384),
                                         [@procedure_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_sqlagent_add_job([@delete_level] int, [@description] nvarchar(512), [@enabled] tinyint,
                                         [@job_id] uniqueidentifier, [@job_name] sysname, [@notify_level_eventlog] int,
                                         [@start_step_id] int) as -- missing source code
go

create procedure sys.sp_sqlagent_add_jobstep([@additional_parameters] nvarchar(max), [@cmdexec_success_code] int,
                                             [@command] nvarchar(max), [@database_name] sysname,
                                             [@database_user_name] sysname, [@flags] int, [@job_id] uniqueidentifier,
                                             [@job_name] sysname, [@on_fail_action] tinyint, [@on_fail_step_id] int,
                                             [@on_success_action] tinyint, [@on_success_step_id] int,
                                             [@os_run_priority] int, [@output_file_name] nvarchar(200),
                                             [@retry_attempts] int, [@retry_interval] int, [@server] sysname,
                                             [@step_id] int, [@step_name] sysname, [@step_uid] uniqueidentifier,
                                             [@subsystem] nvarchar(40)) as -- missing source code
go

create procedure sys.sp_sqlagent_delete_job([@job_id] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_sqlagent_help_jobstep([@job_id] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_sqlagent_log_job_history([@job_id] uniqueidentifier, [@message] nvarchar(4000),
                                                 [@operator_id_emailed] int, [@operator_id_paged] int,
                                                 [@retries_attempted] int, [@run_date] int, [@run_duration] int,
                                                 [@run_status] int, [@run_time] int, [@sql_message_id] int,
                                                 [@sql_severity] int, [@step_id] int) as -- missing source code
go

create procedure sys.sp_sqlagent_start_job([@job_id] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_sqlagent_stop_job([@job_id] uniqueidentifier) as -- missing source code
go

create procedure sys.sp_sqlagent_verify_database_context() as -- missing source code
go

create procedure sys.sp_sqlagent_write_jobstep_log([@job_id] uniqueidentifier, [@log_text] nvarchar(max),
                                                   [@step_id] int) as -- missing source code
go

create procedure sys.sp_sqlexec([@p1] text) as -- missing source code
go

create procedure sys.sp_srvrolepermission([@srvrolename] sysname) as -- missing source code
go

create procedure sys.sp_start_user_instance() as -- missing source code
go

create procedure sys.sp_startmergepullsubscription_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_startmergepushsubscription_agent([@publication] sysname, [@subscriber] sysname,
                                                         [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_startpublication_snapshot([@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_startpullsubscription_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_startpushsubscription_agent([@publication] sysname, [@publisher] sysname, [@subscriber] sysname,
                                                    [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_statistics([@accuracy] char, [@index_name] sysname, [@is_unique] char, [@table_name] sysname,
                                   [@table_owner] sysname, [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_statistics_100([@accuracy] char, [@index_name] sysname, [@is_unique] char,
                                       [@table_name] sysname, [@table_owner] sysname,
                                       [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_statistics_rowset([@table_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_statistics_rowset2([@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_stopmergepullsubscription_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_stopmergepushsubscription_agent([@publication] sysname, [@subscriber] sysname,
                                                        [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_stoppublication_snapshot([@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_stoppullsubscription_agent([@publication] sysname, [@publisher] sysname, [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_stoppushsubscription_agent([@publication] sysname, [@publisher] sysname, [@subscriber] sysname,
                                                   [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_stored_procedures([@fUsePattern] bit, [@sp_name] nvarchar(390), [@sp_owner] nvarchar(384),
                                          [@sp_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_subscribe([@article] sysname, [@destination_db] sysname, [@loopback_detection] nvarchar(5),
                                  [@publication] sysname, [@sync_type] nvarchar(15)) as -- missing source code
go

create procedure sys.sp_subscription_cleanup([@from_backup] bit, [@publication] sysname, [@publisher] sysname,
                                             [@publisher_db] sysname,
                                             [@reserved] nvarchar(10)) as -- missing source code
go

create procedure sys.sp_subscriptionsummary([@publication] sysname, [@publisher] sysname, [@subscriber] sysname,
                                            [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_syspolicy_execute_policy([@event_data] xml, [@policy_name] sysname, [@synchronous] bit) as -- missing source code
go

create procedure sys.sp_syspolicy_subscribe_to_policy_category([@policy_category] sysname) as -- missing source code
go

create procedure sys.sp_syspolicy_unsubscribe_from_policy_category([@policy_category] sysname) as -- missing source code
go

create procedure sys.sp_syspolicy_update_ddl_trigger() as -- missing source code
go

create procedure sys.sp_syspolicy_update_event_notification() as -- missing source code
go

create procedure sys.sp_table_constraints_rowset([@constraint_catalog] sysname, [@constraint_name] sysname,
                                                 [@constraint_schema] sysname, [@constraint_type] nvarchar(255),
                                                 [@table_catalog] sysname, [@table_name] sysname,
                                                 [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_table_constraints_rowset2([@constraint_catalog] sysname, [@constraint_name] sysname,
                                                  [@constraint_schema] sysname, [@constraint_type] nvarchar(255),
                                                  [@table_catalog] sysname,
                                                  [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_table_privileges([@fUsePattern] bit, [@table_name] nvarchar(384), [@table_owner] nvarchar(384),
                                         [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_table_privileges_ex([@fUsePattern] bit, [@table_catalog] sysname, [@table_name] sysname,
                                            [@table_schema] sysname, [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_table_privileges_rowset([@grantee] sysname, [@grantor] sysname, [@table_name] sysname,
                                                [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_table_privileges_rowset2([@grantee] sysname, [@grantor] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_table_privileges_rowset_rmt([@grantee] sysname, [@grantor] sysname, [@table_catalog] sysname,
                                                    [@table_name] sysname, [@table_schema] sysname,
                                                    [@table_server] sysname) as -- missing source code
go

create procedure sys.sp_table_statistics2_rowset([@stat_catalog] sysname, [@stat_name] sysname, [@stat_schema] sysname,
                                                 [@table_catalog] sysname, [@table_name] sysname,
                                                 [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_table_statistics_rowset([@table_name_dummy] sysname) as -- missing source code
go

create procedure sys.sp_table_type_columns_100([@ODBCVer] int, [@column_name] nvarchar(384), [@fUsePattern] bit,
                                               [@table_name] nvarchar(384), [@table_owner] nvarchar(384),
                                               [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_table_type_columns_100_rowset([@column_name] sysname, [@table_name] sysname,
                                                      [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_table_type_pkeys([@table_name] sysname, [@table_owner] sysname,
                                         [@table_qualifier] sysname) as -- missing source code
go

create procedure sys.sp_table_type_primary_keys_rowset([@table_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_table_types([@fUsePattern] bit, [@table_name] nvarchar(384), [@table_owner] nvarchar(384),
                                    [@table_qualifier] sysname, [@table_type] varchar(100)) as -- missing source code
go

create procedure sys.sp_table_types_rowset([@table_name] sysname, [@table_schema] sysname) as -- missing source code
go

create procedure sys.sp_table_validation([@column_list] nvarchar(max), [@expected_checksum] numeric(18),
                                         [@expected_rowcount] bigint, [@full_or_fast] tinyint, [@owner] sysname,
                                         [@rowcount_only] smallint, [@shutdown_agent] bit, [@table] sysname,
                                         [@table_name] sysname) as -- missing source code
go

create procedure sys.sp_tablecollations([@object] nvarchar(4000)) as -- missing source code
go

create procedure sys.sp_tablecollations_100([@object] nvarchar(4000)) as -- missing source code
go

create procedure sys.sp_tablecollations_90([@object] nvarchar(4000)) as -- missing source code
go

create procedure sys.sp_tableoption([@OptionName] varchar(35), [@OptionValue] varchar(12),
                                    [@TableNamePattern] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_tables([@fUsePattern] bit, [@table_name] nvarchar(384), [@table_owner] nvarchar(384),
                               [@table_qualifier] sysname, [@table_type] varchar(100)) as -- missing source code
go

create procedure sys.sp_tables_ex([@fUsePattern] bit, [@table_catalog] sysname, [@table_name] sysname,
                                  [@table_schema] sysname, [@table_server] sysname,
                                  [@table_type] sysname) as -- missing source code
go

create procedure sys.sp_tables_info_90_rowset([@table_name] sysname, [@table_schema] sysname,
                                              [@table_type] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_tables_info_90_rowset2([@table_schema] sysname, [@table_type] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_tables_info_90_rowset2_64([@table_schema] sysname, [@table_type] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_tables_info_90_rowset_64([@table_name] sysname, [@table_schema] sysname,
                                                 [@table_type] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_tables_info_rowset([@table_name] sysname, [@table_schema] sysname,
                                           [@table_type] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_tables_info_rowset2([@table_schema] sysname, [@table_type] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_tables_info_rowset2_64([@table_schema] sysname, [@table_type] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_tables_info_rowset_64([@table_name] sysname, [@table_schema] sysname,
                                              [@table_type] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_tables_rowset([@table_name] sysname, [@table_schema] sysname,
                                      [@table_type] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_tables_rowset2([@table_schema] sysname, [@table_type] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_tables_rowset_rmt([@table_catalog] sysname, [@table_name] sysname, [@table_schema] sysname,
                                          [@table_server] sysname, [@table_type] sysname) as -- missing source code
go

create procedure sys.sp_tableswc([@fTableCreated] bit, [@fUsePattern] bit, [@table_name] nvarchar(384),
                                 [@table_owner] nvarchar(384), [@table_qualifier] sysname,
                                 [@table_type] varchar(100)) as -- missing source code
go

create procedure sys.sp_testlinkedserver() as -- missing source code
go

create procedure sys.sp_trace_create() as -- missing source code
go

create procedure sys.sp_trace_generateevent() as -- missing source code
go

create procedure sys.sp_trace_getdata([@records] int, [@traceid] int) as -- missing source code
go

create procedure sys.sp_trace_setevent() as -- missing source code
go

create procedure sys.sp_trace_setfilter() as -- missing source code
go

create procedure sys.sp_trace_setstatus() as -- missing source code
go

create procedure sys.sp_try_set_session_context() as -- missing source code
go

create procedure sys.sp_unbindefault([@futureonly] varchar(15), [@objname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_unbindrule([@futureonly] varchar(15), [@objname] nvarchar(776)) as -- missing source code
go

create procedure sys.sp_unprepare() as -- missing source code
go

create procedure sys.sp_unregister_custom_scripting([@article] sysname, [@publication] sysname, [@type] varchar(16)) as -- missing source code
go

create procedure sys.sp_unregistercustomresolver([@article_resolver] nvarchar(255)) as -- missing source code
go

create procedure sys.sp_unsetapprole([@cookie] varbinary(8000)) as -- missing source code
go

create procedure sys.sp_unsubscribe([@article] sysname, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_update_agent_profile([@agent_id] int, [@agent_type] int, [@profile_id] int) as -- missing source code
go

create procedure sys.sp_update_user_instance() as -- missing source code
go

create procedure sys.sp_updateextendedproperty([@level0name] sysname, [@level0type] varchar(128), [@level1name] sysname,
                                               [@level1type] varchar(128), [@level2name] sysname,
                                               [@level2type] varchar(128), [@name] sysname,
                                               [@value] sql_variant) as -- missing source code
go

create procedure sys.sp_updatestats([@resample] char(8)) as -- missing source code
go

create procedure sys.sp_upgrade_log_shipping() as -- missing source code
go

create procedure sys.sp_user_counter1([@newvalue] int) as -- missing source code
go

create procedure sys.sp_user_counter10([@newvalue] int) as -- missing source code
go

create procedure sys.sp_user_counter2([@newvalue] int) as -- missing source code
go

create procedure sys.sp_user_counter3([@newvalue] int) as -- missing source code
go

create procedure sys.sp_user_counter4([@newvalue] int) as -- missing source code
go

create procedure sys.sp_user_counter5([@newvalue] int) as -- missing source code
go

create procedure sys.sp_user_counter6([@newvalue] int) as -- missing source code
go

create procedure sys.sp_user_counter7([@newvalue] int) as -- missing source code
go

create procedure sys.sp_user_counter8([@newvalue] int) as -- missing source code
go

create procedure sys.sp_user_counter9([@newvalue] int) as -- missing source code
go

create procedure sys.sp_usertypes_rowset([@type_name] sysname, [@type_schema] sysname) as -- missing source code
go

create procedure sys.sp_usertypes_rowset2([@type_schema] sysname) as -- missing source code
go

create procedure sys.sp_usertypes_rowset_rmt([@assembly_id] int, [@type_catalog] sysname, [@type_name] sysname,
                                             [@type_schema] sysname, [@type_server] sysname) as -- missing source code
go

create procedure sys.sp_validate_redirected_publisher([@original_publisher] sysname, [@publisher_db] sysname,
                                                      [@redirected_publisher] sysname) as -- missing source code
go

create procedure sys.sp_validate_replica_hosts_as_publishers([@original_publisher] sysname, [@publisher_db] sysname,
                                                             [@redirected_publisher] sysname) as -- missing source code
go

create procedure sys.sp_validatecache([@article] sysname, [@publication] sysname, [@publisher] sysname) as -- missing source code
go

create procedure sys.sp_validatelogins() as -- missing source code
go

create procedure sys.sp_validatemergepublication([@level] tinyint, [@publication] sysname) as -- missing source code
go

create procedure sys.sp_validatemergepullsubscription([@level] tinyint, [@publication] sysname, [@publisher] sysname,
                                                      [@publisher_db] sysname) as -- missing source code
go

create procedure sys.sp_validatemergesubscription([@level] tinyint, [@publication] sysname, [@subscriber] sysname,
                                                  [@subscriber_db] sysname) as -- missing source code
go

create procedure sys.sp_validlang([@name] sysname) as -- missing source code
go

create procedure sys.sp_validname([@name] sysname, [@raise_error] bit) as -- missing source code
go

create procedure sys.sp_verifypublisher([@publisher] sysname) as -- missing source code
go

create procedure sys.sp_views_rowset([@view_name] sysname, [@view_schema] sysname) as -- missing source code
go

create procedure sys.sp_views_rowset2([@view_schema] sysname) as -- missing source code
go

create procedure sys.sp_vupgrade_mergeobjects([@login] sysname, [@password] sysname, [@security_mode] bit) as -- missing source code
go

create procedure sys.sp_vupgrade_mergetables([@remove_repl] bit) as -- missing source code
go

create procedure sys.sp_vupgrade_replication([@force_remove] tinyint, [@login] sysname, [@password] sysname,
                                             [@security_mode] bit, [@ver_old] int) as -- missing source code
go

create procedure sys.sp_vupgrade_replsecurity_metadata() as -- missing source code
go

create procedure sys.sp_who([@loginame] sysname) as -- missing source code
go

create procedure sys.sp_who2([@loginame] sysname) as -- missing source code
go

create procedure sys.sp_xml_preparedocument() as -- missing source code
go

create procedure sys.sp_xml_removedocument() as -- missing source code
go

create procedure sys.sp_xml_schema_rowset([@collection_name] sysname, [@schema_name] sysname,
                                          [@target_namespace] sysname) as -- missing source code
go

create procedure sys.sp_xml_schema_rowset2([@schema_name] sysname, [@target_namespace] sysname) as -- missing source code
go

create procedure sys.sp_xp_cmdshell_proxy_account() as -- missing source code
go

create procedure sys.sp_xtp_bind_db_resource_pool([@database_name] sysname, [@pool_name] sysname) as -- missing source code
go

create procedure sys.sp_xtp_checkpoint_force_garbage_collection([@dbname] sysname) as -- missing source code
go

create procedure sys.sp_xtp_control_proc_exec_stats([@new_collection_value] bit, [@old_collection_value] bit) as -- missing source code
go

create procedure sys.sp_xtp_control_query_exec_stats([@database_id] int, [@new_collection_value] bit,
                                                     [@old_collection_value] bit,
                                                     [@xtp_object_id] int) as -- missing source code
go

create procedure sys.sp_xtp_flush_temporal_history([@object_name] sysname, [@schema_name] sysname) as -- missing source code
go

create procedure sys.sp_xtp_kill_active_transactions([@database_name] sysname) as -- missing source code
go

create procedure sys.sp_xtp_merge_checkpoint_files([@database_name] sysname, [@transaction_lower_bound] bigint,
                                                   [@transaction_upper_bound] bigint) as -- missing source code
go

create procedure sys.sp_xtp_objects_present([@database_name] sysname, [@xtp_objects_present] bit) as -- missing source code
go

create procedure sys.sp_xtp_set_memory_quota([@database_name] sysname, [@target_user_memory_quota] bigint) as -- missing source code
go

create procedure sys.sp_xtp_slo_can_downgrade([@database_name] sysname, [@xtp_can_downgrade] bit) as -- missing source code
go

create procedure sys.sp_xtp_slo_downgrade_finished([@database_name] sysname, [@result] bit) as -- missing source code
go

create procedure sys.sp_xtp_slo_prepare_to_downgrade([@database_name] sysname, [@xtp_can_downgrade] bit) as -- missing source code
go

create procedure sys.sp_xtp_unbind_db_resource_pool([@database_name] sysname) as -- missing source code
go

create procedure sys.xp_availablemedia() as -- missing source code
go

create procedure sys.xp_cmdshell() as -- missing source code
go

create procedure sys.xp_create_subdir() as -- missing source code
go

create procedure sys.xp_delete_file() as -- missing source code
go

create procedure sys.xp_dirtree() as -- missing source code
go

create procedure sys.xp_enum_oledb_providers() as -- missing source code
go

create procedure sys.xp_enumerrorlogs() as -- missing source code
go

create procedure sys.xp_enumgroups() as -- missing source code
go

create procedure sys.xp_fileexist() as -- missing source code
go

create procedure sys.xp_fixeddrives() as -- missing source code
go

create procedure sys.xp_get_tape_devices() as -- missing source code
go

create procedure sys.xp_getnetname() as -- missing source code
go

create procedure sys.xp_grantlogin([@loginame] sysname, [@logintype] varchar(5)) as -- missing source code
go

create procedure sys.xp_instance_regaddmultistring() as -- missing source code
go

create procedure sys.xp_instance_regdeletekey() as -- missing source code
go

create procedure sys.xp_instance_regdeletevalue() as -- missing source code
go

create procedure sys.xp_instance_regenumkeys() as -- missing source code
go

create procedure sys.xp_instance_regenumvalues() as -- missing source code
go

create procedure sys.xp_instance_regread() as -- missing source code
go

create procedure sys.xp_instance_regremovemultistring() as -- missing source code
go

create procedure sys.xp_instance_regwrite() as -- missing source code
go

create procedure sys.xp_logevent() as -- missing source code
go

create procedure sys.xp_loginconfig() as -- missing source code
go

create procedure sys.xp_logininfo([@acctname] sysname, [@option] varchar(10),
                                  [@privilege] varchar(10)) as -- missing source code
go

create procedure sys.xp_msver() as -- missing source code
go

create procedure sys.xp_msx_enlist() as -- missing source code
go

create procedure sys.xp_passAgentInfo() as -- missing source code
go

create procedure sys.xp_prop_oledb_provider() as -- missing source code
go

create procedure sys.xp_qv() as -- missing source code
go

create procedure sys.xp_readerrorlog() as -- missing source code
go

create procedure sys.xp_regaddmultistring() as -- missing source code
go

create procedure sys.xp_regdeletekey() as -- missing source code
go

create procedure sys.xp_regdeletevalue() as -- missing source code
go

create procedure sys.xp_regenumkeys() as -- missing source code
go

create procedure sys.xp_regenumvalues() as -- missing source code
go

create procedure sys.xp_regread() as -- missing source code
go

create procedure sys.xp_regremovemultistring() as -- missing source code
go

create procedure sys.xp_regwrite() as -- missing source code
go

create procedure sys.xp_repl_convert_encrypt_sysadmin_wrapper([@password] nvarchar(524)) as -- missing source code
go

create procedure sys.xp_replposteor() as -- missing source code
go

create procedure sys.xp_revokelogin([@loginame] sysname) as -- missing source code
go

create procedure sys.xp_servicecontrol() as -- missing source code
go

create procedure sys.xp_sprintf() as -- missing source code
go

create procedure sys.xp_sqlagent_enum_jobs() as -- missing source code
go

create procedure sys.xp_sqlagent_is_starting() as -- missing source code
go

create procedure sys.xp_sqlagent_monitor() as -- missing source code
go

create procedure sys.xp_sqlagent_notify() as -- missing source code
go

create procedure sys.xp_sqlagent_param() as -- missing source code
go

create procedure sys.xp_sqlmaint() as -- missing source code
go

create procedure sys.xp_sscanf() as -- missing source code
go

create procedure sys.xp_subdirs() as -- missing source code
go

create procedure sys.xp_sysmail_activate() as -- missing source code
go

create procedure sys.xp_sysmail_attachment_load() as -- missing source code
go

create procedure sys.xp_sysmail_format_query() as -- missing source code
go


