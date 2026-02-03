/**
 * Skillforge - Claude Code skill 저장소
 */

export const VERSION = '0.1.0';

export interface Skill {
  name: string;
  description: string;
  triggers: string[];
  prompt: string;
}

export function parseSkill(content: string): Skill | null {
  // TODO: markdown skill 파싱 구현
  return null;
}
