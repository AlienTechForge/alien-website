import { NextResponse } from "next/server";
import { projectsData } from "@/lib/data";

export async function GET() {
  const projects = projectsData.map((p) => ({
    title: p.title,
    description: p.description,
    tags: [...p.tags],
    ctalink: "ctalink" in p ? (p as any).ctalink : null,
  }));

  return NextResponse.json(projects, {
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET",
    },
  });
}
