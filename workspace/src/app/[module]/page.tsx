import type { Metadata } from "next"
import { notFound } from "next/navigation"

import { ModulePage } from "@/components/module-page"
import { moduleIds } from "@/lib/models"
import { getModule } from "@/lib/workspace-data"

interface ModuleRouteProps {
  params: Promise<{ module: string }>
}

export function generateStaticParams() {
  return moduleIds.map((module) => ({ module }))
}

export async function generateMetadata({ params }: ModuleRouteProps): Promise<Metadata> {
  const { module: moduleId } = await params
  const workspaceModule = getModule(moduleId)
  return workspaceModule ? { title: workspaceModule.title, description: workspaceModule.description } : {}
}

export default async function ModuleRoute({ params }: ModuleRouteProps) {
  const { module: moduleId } = await params
  const workspaceModule = getModule(moduleId)
  if (!workspaceModule) notFound()
  return <ModulePage module={workspaceModule} />
}
