#' experDesign: Expert experiment design in batches
#'
#' Enables easy distribution of samples per batch avoiding batch and
#' confounding effects by randomization of the variables in each batch.
#'
#' The most important function is [design()], which distributes
#' samples in batches according to the information provided.
#'
#' To help in the bench there is the [inspect()] function that appends
#' the group to the data provided.
#'
#' If you have a grid or some spatial data, you might want to look at the
#' [spatial()] function to distribute the samples while keeping the original
#' design.
#'
#' In case an experiment was half processed and you need to extend it you can
#'  use [follow_up()] or [follow_up2()]. It helps selecting which samples
#'  already used should be used in the follow up.
#' @author Lluís Revilla
#' @name experDesign-package
#' @aliases experDesign
"_PACKAGE"
