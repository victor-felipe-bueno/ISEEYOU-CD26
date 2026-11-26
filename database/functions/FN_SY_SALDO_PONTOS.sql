CREATE NONCLUSTERED INDEX IX_MOVIMENTACAO_PONTOS_USUARIO 
ON TB_SY_MOVIMENTACAO_PONTOS (id_usuario) 
INCLUDE (tp_movimentacao, nr_pontos);

CREATE FUNCTION dbo.FN_SY_SALDO_PONTOS(@usuario INT)

RETURNS INT
AS
BEGIN
    DECLARE @saldo INT = (
        SELECT SUM(
            CASE
                WHEN tp_movimentacao = 'C' THEN nr_pontos
                WHEN tp_movimentacao = 'D' THEN -nr_pontos
                ELSE 0
            END
            ) 
        FROM TB_SY_MOVIMENTACAO_PONTOS 
        WHERE id_usuario = @usuario);

    RETURN ISNULL(@saldo, 0);
END;