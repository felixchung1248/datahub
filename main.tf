resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "datahub-ns"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].name,
      # other attributes to ignore
    ]
  }
}

resource "kubernetes_secret" "mysql_secrets" {
  metadata {
    name = "mysql-secrets"
	namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  data = {
    "mysql-root-password" = "datahub"
  }
  
  depends_on = [kubernetes_namespace.namespace]
}

resource "kubernetes_secret" "neo4j-secrets" {
  metadata {
    name = "neo4j-secrets"
	namespace = kubernetes_namespace.namespace.metadata[0].name
  }

  data = {
    "neo4j-password" = "datahub"
	"NEO4J_AUTH" = "neo4j/datahub"
  }
  
  depends_on = [kubernetes_namespace.namespace]
}

resource "helm_release" "prerequisites" {
  name       = "prerequisites"
  chart      = "/chart/datahub-prerequisites-0.1.6.tgz"
  namespace  = kubernetes_namespace.namespace.metadata[0].name
  create_namespace = true
  
  depends_on = [kubernetes_secret.mysql_secrets, kubernetes_secret.neo4j-secrets]
}


resource "helm_release" "datahub" {
  name       = "datahub"
  chart      = "/chart/datahub-0.3.27.tgz"
  namespace  = kubernetes_namespace.namespace.metadata[0].name
  create_namespace = true
  
  depends_on = [helm_release.prerequisites]
}


