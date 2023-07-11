USE [clinica]
GO
/****** Object:  Trigger [dbo].[Atualiza_Pedido_Exame]    Script Date: 11/07/2023 19:41:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER trigger [dbo].[Atualiza_Pedido_Exame]
on [dbo].[pedido_exame]
after insert
as
begin 
-- procedimentos dentro da trigger
SET NOCOUNT ON
declare @num_ped as integer;
select @num_ped = numero_pedido from inserted;
declare @num_cons as integer;
select @num_cons = fk_consulta_numero_consulta from inserted;
declare @cod_ex as integer;
select @cod_ex = fk_exame_codigo from inserted;
declare @prc as money;

select @prc = preco from exame where codigo = @cod_ex;
declare @cpf_pac as varchar(20);
select @cpf_pac = fk_paciente_cpf from consulta where numero_consulta = @num_cons;
declare @tp_plan as varchar(20);
select @tp_plan = tipo_plano from paciente where cpf = @cpf_pac;

if @tp_plan = 'Especial'
begin
update pedido_exame set valor_pagar = @prc - @prc * 100 / 100 where
numero_pedido = @num_ped;
end
if @tp_plan = 'Padrão'
begin
update pedido_exame set valor_pagar = @prc - @prc * 30 / 100 where
numero_pedido = @num_ped;
end
if @tp_plan = 'Básico'
begin
update pedido_exame set valor_pagar = @prc - @prc * 10 / 100 where
numero_pedido = @num_ped;
end
print 'Trigger (Atualiza Pedido de Exame) Encerrada';
end
execute Atualiza_Pedido_Exame;

