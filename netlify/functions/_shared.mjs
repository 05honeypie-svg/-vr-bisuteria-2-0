import { createClient } from '@supabase/supabase-js';
const cors={"Access-Control-Allow-Origin":"*","Access-Control-Allow-Headers":"authorization, x-client-info, apikey, content-type","Access-Control-Allow-Methods":"POST, OPTIONS"};
export const headers={...cors,"Content-Type":"application/json"};
export function client(){const url=process.env.SUPABASE_URL,key=process.env.SUPABASE_SERVICE_ROLE_KEY;if(!url||!key)throw new Error('Backend no configurado');return createClient(url,key,{auth:{persistSession:false}});}
export function reply(statusCode,body){return {statusCode,headers,body:JSON.stringify(body)};}
export function parse(event){return JSON.parse(event.body||'{}');}
