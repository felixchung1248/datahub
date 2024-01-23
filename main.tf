resource "helm_release" "datahub" {
  name       = "datahub"
  chart      = "/chart/charts/datahub"
  namespace  = "datahub-ns"
  create_namespace = true
}