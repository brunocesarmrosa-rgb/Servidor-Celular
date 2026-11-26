# Escolha do modelo (GGUF Q4_K_M)
| RAM do celular | Modelo | Arquivo | Observação |
|---|---|---|---|
| 4 GB | Qwen2.5 0.5B Instruct | ~0.4 GB | rápido, qualidade básica |
| 6 GB | **Qwen2.5 1.5B Instruct (padrão)** | ~1.1 GB | bom português, equilíbrio |
| 8 GB | Qwen2.5 3B / Llama 3.2 3B | ~2 GB | melhor resposta, mais lento |
| 12 GB+ | Phi-4 Mini 3.8B / Gemma 3 4B | ~2.5 GB | melhor qualidade, mais calor |

Regra: o arquivo do modelo deve ocupar no máximo metade da RAM livre. Para trocar, edite MODEL_URL e MODEL_FILE no config.env e rode /instalar e /iniciar.
