{ pkgs, lib, ... }:{
  systemd.user.services.llama-gemma = {
    Unit = {
      Description = "Llama.cpp On-Demand Server for Gemma 3";
    };
    Service = {
      ExecStart = "${pkgs.llama-cpp-vulkan}/bin/llama-server -m %h/.lmstudio/models/lmstudio-community/gemma-3-4B-it-QAT-GGUF/gemma-3-4B-it-QAT-Q4_0.gguf --port 8080 --ctx-size 81920";
      Restart = "no";
    };
  };
  systemd.user.services.llama-lfm = {
    Unit = {
      Description = "Llama.cpp On-Demand Server for Gemma 3";
    };
    Service = {
      ExecStart = "${pkgs.llama-cpp-vulkan}/bin/llama-server -m %h/.lmstudio/models/lmstudio-community/LFM2.5-1.2B-Instruct-GGUF/LFM2.5-1.2B-Instruct-Q8_0.gguf --port 8080 --ctx-size 81920";
      Restart = "no";
    };
  };
}
