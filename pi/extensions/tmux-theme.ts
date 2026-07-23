import { execFileSync } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

function tmuxTheme(): "light" | "dark" | undefined {
  if (!process.env.TMUX) return undefined;

  try {
    const value = execFileSync("tmux", ["show-option", "-gv", "@dotfiles_theme"], {
      encoding: "utf8",
      stdio: ["ignore", "pipe", "ignore"],
    }).trim();
    return value === "light" ? "light" : "dark";
  } catch {
    return undefined;
  }
}

export default function (pi: ExtensionAPI) {
  pi.on("session_start", (_event, ctx) => {
    if (tmuxTheme() === "light") {
      ctx.ui.setTheme("kanagawa-lotus");
    }
  });
}
