from huggingface_hub import login
login(token=userdata.get('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'))

# Load model directly
from transformers import AutoTokenizer, AutoModelForCausalLM

tokenizer = AutoTokenizer.from_pretrained("google/gemma-3-270m-it")
model = AutoModelForCausalLM.from_pretrained("google/gemma-3-270m-it")

