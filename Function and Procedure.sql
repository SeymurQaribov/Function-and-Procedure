/****** Object:  UserDefinedFunction [dbo].[sm_status_function]    Script Date: 20.02.2023 16:58:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[sm_status_function]

(
	@muq_sened nvarchar(50)
)
RETURNS  decimal(18,2)
BEGIN
declare @mebleg decimal(18,2)


  select  @mebleg = s.mebleg - isnull(k.mebleg,0)
  from sm_status s
  left join (select sum(mebleg) mebleg,kontra ,nov 
                from  sm_kmd 
			   group by kontra,nov )k on s.idn = k.kontra  and k.nov=4
			   where  s.muq_sened=@muq_sened 
			   
RETURN (@mebleg)

END


ALTER procedure [dbo].[sm_status_kmd]
@emel_idn int,
@vez int,
@text nvarchar(200) out,
@cavab int out
as 
declare @mebleg decimal(18,2),
@mebleg2 decimal(18,2),
@mebleg3 decimal(18,2)
 
if @vez < 4
begin

select @mebleg = dbo.sm_status_function(s.muq_sened),@mebleg3 = s.mebleg, @mebleg3 = k.mebleg 
from sm_status as s 
inner join sm_kmd as k on s.idn = k.kontra and k.idn = @emel_idn
where k.nov = 4

if  0 > @mebleg 
begin
set @cavab = 0
set @text = concat(N'Qaliqdan elave pul odeye bilmezsiz: ',( @mebleg3 + @mebleg) )
end
end