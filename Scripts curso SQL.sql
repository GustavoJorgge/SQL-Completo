use curso_sql;
*.rb linguist-language=SQL

insert into funcionarios values (1,'Fernando', 1400, 'TI');
insert into funcionarios (nome,salario, departamento)values ('Guilherme', 2500, 'Departamento Pessoal');
insert into funcionarios (nome,salario, departamento)values ('Maria', 1800, 'TI');
insert into funcionarios (nome,salario, departamento)values ('Joice', 2700, 'Vendedora');
insert into funcionarios (nome,salario, departamento)values ('Claudio', 900, 'Jovem Aprendiz');
insert into funcionarios (nome,salario, departamento)values ('Camila', 2700, 'Vendedora');

select nome,salario from funcionarios ;

select * from funcionarios where salario != 2700;

set sql_safe_updates =0;
/* set sql_safe_updates =1;*/
update funcionarios set salario = round(salario * 1.0, 2);  /*Atualizando salario de todos na tabela*/

update funcionarios set salario = 2000 where id = 5; /*Atualizando salario apenas do id 5*/

delete from funcionarios where id = 4; /* Deletando o id 4 */

insert into veiculos (funcionario_id, veiculos, placa) values (1, 'Gol', 'OWI-0056');
insert into veiculos(funcionario_id, veiculos, placa) values (1, 'Corsa', 'OHG-0099');
insert into veiculos(funcionario_id, veiculos, placa) values (3, 'Moto', 'SBT-0099');
insert into veiculos(funcionario_id, veiculos, placa) values (null, 'Fusca', 'TRA-5099');
select*from veiculos;

update veiculos set funcionario_id = 5 where id = 2;

insert into salarios (faixa,inicio, fim) values ('Analista Jr', 1000,2000);
insert into salarios (faixa,inicio, fim) values ('Gerente', 2500,4000);

select *, faixa from salarios;

select nome,salario from funcionarios f where f.salario > 2000
union /*union all não imprime registros duplicados*/
select nome,salario from funcionarios  where id = 5;

/* Scripts utilizando JOIN */
SELECT * FROM funcionarios;
select * from veiculos;

/* Scripts utilizando INNER JOIN */
select * from funcionarios inner join veiculos on veiculos.funcionario_id = funcionarios.id;
select * from funcionarios f inner join veiculos v on v.funcionario_id = f.id; /* Scripts utilizando JOIN utilizando apelidos */

/* Scripts utilizando LEFT JOIN */
select * from funcionarios left join veiculos on veiculos.funcionario_id = funcionarios.id;

/* Scripts utilizando RIGHT JOIN */
select * from funcionarios right join veiculos on veiculos.funcionario_id = funcionarios.id;

/* Scripts para utilizar FULL JOIN */
select * from funcionarios left join veiculos on veiculos.funcionario_id = funcionarios.id
union
select * from funcionarios right join veiculos on veiculos.funcionario_id = funcionarios.id;

/* Scripts para utilizar EQUI JOIN */
create table cpfs
(
id int unsigned not null ,
cpf varchar(14) not null,
primary key(id),
constraint fk_cpf foreign key (id) references funcionarios (id)
);
/* Scripts para utilizar EQUI JOIN - FORMA TRADICIONAL */
select * from funcionarios inner join cpfs on funcionarios.id = cpfs.id;
select * from funcionarios inner join cpfs using (id);/* Scripts para utilizar EQUI JOIN - FORMA REDUZIDA */

/* Scripts para utilizar SELF JOIN - TABELAS RELACIONANDO COM ELA MESMO */
create table clientes 
(
id int unsigned not null auto_increment,
nome varchar(50) not null,
quem_indicou int unsigned,
primary key (id),
constraint fk_quem_indicou foreign key (quem_indicou) references clientes(id)
);

insert into clientes(id, nome, quem_indicou) values (1,'Lucas',null);
insert into clientes(id,nome,quem_indicou) values (2,'Gabriela',1);
insert into clientes(id,nome,quem_indicou) values (3,'Daniel',2);
insert into clientes(id,nome,quem_indicou) values (4,'Andre',1);

select * from clientes;

/* Scripts para utilizar SELF JOIN - TABELAS RELACIONANDO COM ELA MESMO */
select a.nome AS clientes , b.nome AS quem_indicou from clientes a join clientes b on a.quem_indicou = b.id; /*devemos colocar apelido, pois utilizamos a mesma tabela */

/* Scripts para utilizar relacionamentos triplos */
select * from funcionarios 
inner join veiculos on veiculos.funcionario_id = funcionarios.id 
inner join cpfs on cpfs.id = funcionarios.id;

/* Visões */
create view funcionarios_a as select * from funcionarios where salario >= 1000;

select * from funcionarios_a;
drop view funcionarios_a;
create view funcionarios_a as select * from funcionarios where salario >= 2000;

/* Funções */
/* Script para contar/count */
select count(*)from funcionarios;
select count(*)from funcionarios where salario >2500 and departamento = 'Departamento pessoal';

/* Script para utilizar soma/ SUM */
select sum(salario) from funcionarios;
select sum(salario) from funcionarios where departamento = 'Departamento pessoal';

/* Script para calcular a media/ AVG */
select AVG(salario) from funcionarios;
select AVG(salario) from funcionarios where departamento = 'Departamento pessoal';

/* Script para obter o maior valor/ max e minimo */
select max(salario) from funcionarios;
select min(salario) from funcionarios;

/*Funções de ORDENAÇÃO */
/*Selecionando os valores unicos, sem repetição / DISTINCT */
select distinct (departamento) from funcionarios;

/*Ordenação*/
/*Ordenando a consulta (o padrao do order by é crescente)*/
/*ASC E DESC*/
select * from funcionarios order by nome;
select * from funcionarios order by nome desc;
select * from funcionarios order by departamento,salario; /* Primeiro ira ordenar por departamento e depois por salario*/

/*Funções de PAGINAÇÃO */
/*Limitando o numero de resultado / LIMIT */
select * from funcionarios limit 2;

/*Pulando resultados / offset*/
select * from funcionarios limit 2 offset 1;
select * from funcionarios limit 1,2; /*Pula o primeiro registro e mostra os dois subsequentes */

/*Funções de AGRUPAMENTO*/
/*Agrupamento de registros para operações / GROUP BY */
select departamento, AVG(salario) from funcionarios group by departamento;
select departamento, count(*) from funcionarios group by departamento;

/*Filtro de seleção para agrupamento / HAVING */
select departamento, AVG(salario) from funcionarios group by departamento having avg (salario) > 2000;

/* SUBQUERIES */
/* Realização de consultas com filtro de seleção baseada em uma lista ou outras seleções / in - not in */
select nome,departamento from funcionarios where departamento in('Vendedora','Departamento Pessoal');
select nome,departamento from funcionarios where departamento NOT in(select departamento from funcionarios group by departamento having avg (salario) > 1800);

/* GERENCIANDO ACESSOS */
/* Realizando a criação de usuario */
/*create user 'nome usuario' @ 'local de acesso' identified by 'senha';*/
/*create user 'Gustavo Jorge' @ '120.0.0.10' identified by 'gustavo123'; --> O usuario só conseguira acesso se ele estiver no local de ip informado (segurança)
Exemplo: endereço de um local ip de um servidor WEB - seja PHP/Java/ etc...*/
/*create user 'Gustavo Jorge' @ '%' identified by 'gustavo123'; --> % significa que o usuario pode se conectar de qualquer endereço IP*/
create user 'GustavoJorge'@'localhost' identified by 'gustavo123'; /* Localhost é o endereço da propria maquina, o mysql ir liberar acesso apenas a conexões locais*/

/*Realizando a permissão de acesso*/
GRANT ALL ON curso_sql.* to 'GustavoJorge'@'localhost';

create user 'GustavoJorge'@'%' identified by 'gustavoviagem';
GRANT SELECT ON curso_sql.* TO 'GustavoJorge'@'localhost';
GRANT INSERT ON curso_sql.funcionarios TO 'GustavoJorge'@'localhost'; /* -> da acesso para inserir dados*/
/*GRANT SELECT ON curso_sql.funcionarios TO 'GustavoJorge'@'%';*/

/*REMOVENDO PERMISSÃO DE ACESSO*/
REVOKE INSERT ON curso_sql.funcionarios from 'GustavoJorge'@'localhost';
REVOKE SELECT ON curso_sql.* from 'GustavoJorge'@'%'; /* Não é possivel remover acesso apenas de uma tabela, ou se tira de todas ou de nenhuma*/

GRANT SELECT ON curso_sql.funcionarios to 'GustavoJorge'@'%';
GRANT SELECT ON curso_sql.veiculos to 'GustavoJorge'@'%';

REVOKE ALL ON curso_sql.* from 'GustavoJorge'@'localhost';

/*Deletando usuarios*/
DROP USER 'GustavoJorge'@'localhost';
DROP USER 'GustavoJorge'@'%';

/*Consultando usuarios no servidor*/
SELECT user From mysql.user;
/*CONSULTANDO permissões de usuarios*/
SHOW GRANTS FOR 'GustavoJorge'@'localhost';

/* TRANSAÇÕES - ACID */
show engines; /* Mostra os mecanismos de transções que o SQL fornece*/

/*Ao criarmos as tabelas devemos analisar a sua necessidade de realizar transações ou não */
create table contas_bancarias
(
id int unsigned not null auto_increment ,
titular varchar(45) not null,
saldo double not null,
primary key(id)
) engine = InnoDB; /*cria a tabela utilizando o mecanismo de armazenamento InnoDB */

insert into contas_bancarias (titular,saldo) values ('Gustavo', 1000);
insert into contas_bancarias (titular,saldo) values ('Maria',200);

select *from contas_bancarias;

/* trabalhando as transações */

 /*quando inicia a transação, apenas o usuario que iniciou a transação pode finaliza-la, fazendo assim que as outras fiquem em stand by */
start transaction;
update contas_bancarias set saldo = saldo - 100 where id = 1;
update contas_bancarias set saldo = saldo + 100 where id = 2;
rollback; /* retorna as transações */

/* Ao dar o comando COMMIT a transação é concluida e a tabela fica disponivel para outros usuarios */
start transaction;
update contas_bancarias set saldo = saldo - 100 where id = 1;
update contas_bancarias set saldo = saldo + 100 where id = 2;
commit; 

/* STORED PROCEDURES E TRIGGERS */
/* AÇÕES PRÉ PROGRAMADAS PARA SEREM EXECUTADAS NO BANCO DE DADOS */

create table pedidos
(
	id int unsigned not null auto_increment,
    descricao varchar (100) not null,
    valor double not null default '0',
    pago varchar (3) not null default 'Não',
    primary key (id)
);

select * from pedidos;

insert into pedidos (descricao,valor,pago) values ('Televisao', 2500,'SIM');
insert into pedidos (descricao,valor) values ('Notebook', 3000);
insert into pedidos (descricao,valor) values ('Geladeira', 3250);
update pedidos set pago = 'Sim' where id = 9;

create table estoque
(
 id int unsigned not null auto_increment,
 descricao varchar(50) not null,
 quantidade int not null,
 primary key(id)
);

insert into estoque (descricao, quantidade) values ('Fogao', 5);
insert into estoque (descricao, quantidade) values ('Televisao', 3);
insert into estoque (descricao, quantidade) values ('Mouse', 2);
insert into estoque (descricao, quantidade) values ('Forno', 2);
select *from estoque;

/*Stored Procedures*/
call limpa_pedidos(); /* Chamando a stored procedures, isto facilita a centralização do codigo para nao ter que fazer alterações em APIS com outros sistemas */

/*Triggers*/
create trigger gatilho_limpa_pedidos /* criando um gatilho */
before insert  /* tipo da trigger - sera executado antes que o registro seja incluido */
on estoque /* informando a tabela */
for each row /* para cada uma das inserções */
call limpa_pedidos(); /* execução */

