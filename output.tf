output "frontend_id" {
    value = azurerm_lb.lb.id
    description = "The id of the Frontend IP Configuration."
}