
export const handler = async event => {
  const { client, reply } = await import('./_shared.mjs');

  if (event.httpMethod !== 'GET') {
    return reply(405, { error: 'Método no permitido' });
  }

  try {
    const db = client();

    const { count, error } = await db
      .from('visitors')
      .select('*', { count: 'exact', head: true });

    if (error) throw error;

    return reply(200, {
      registrations: count ?? 0
    });
  } catch (e) {
    return reply(500, {
      error: 'No se pudo consultar el contador'
    });
  }
};
