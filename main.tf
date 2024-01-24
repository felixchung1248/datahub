resource "helm_release" "datahub" {
  name       = "datahub"
  chart      = "/chart"
  namespace  = "datahub-ns"
  create_namespace = true
}