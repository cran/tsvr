#' Basic methods for the \code{tsvreq_classic} class
#' 
#' Set, get, summary, print and plot methods for the \code{tsvreq_classic} class.
#' 
#' @param object,x,obj An object of class \code{tsvreq_classic}
#' @param newval A new value, for the \code{set_*} methods
#' @param filename A filename, no extension, could have a path. Used for saving a plot as a pdf. The default value NA causes the default plotting device to be used. 
#' @param ... Passed to plot. Not currently used for other methods, included there only for argument consistency
#' with existing generics.
#' 
#' @return \code{summary.tsvreq_classic} produces a summary of a \code{tsvreq_classic} object.
#' Methods \code{print.tsvreq_classic} and \code{plot.tsvreq_classic} are also available. 
#' For \code{tsvreq_classic} objects, 
#' \code{set_*} and \code{get_*} methods are available for all slots (see
#' the documentation for \code{tsvreq_classic} for a list). The \code{set_*} methods 
#' just throw an error, to prevent breaking the consistency between the 
#' slots of a \code{tsvreq_classic} object.
#'  
#' @author Daniel Reuman, \email{reuman@@ku.edu}
#' 
#' @references 
#' Zhao et al, (In prep) Decomposition of the variance ratio illuminates timescale-specific
#' population and community variability.
#' 
#' @seealso \code{\link{tsvreq_classic}}
#' 
#' @examples
#' X<-matrix(runif(10*100),10,100)
#' res<-tsvreq_classic(X)
#' get_ts(res)
#' print(res)
#' summary(res)
#'  
#' @name tsvreq_classic_methods
NULL
#> NULL

#' @rdname tsvreq_classic_methods
#' @export
summary.tsvreq_classic<-function(object,...)
{
  res<-list(class="tsvreq_classic",
            ts_start=object$ts[1],
            ts_end=object$ts[length(object$ts)],
            ts_length=length(object$ts),
            com_length=length(object$com),
            comnull_length=length(object$comnull),
            tsvr_length=length(object$tsvr),
            wts_length=length(object$tsvr))
  
  #a summary_tsvr object inherits from the list class, but has its own print method
  class(res)<-c("summary_tsvr","list")
  return(res)
}

#' @rdname tsvreq_classic_methods
#' @export
print.tsvreq_classic<-function(x,...)
{
  cat("Object of class tsvreq_classic:\n")
  cat(" ts, a length",length(x$ts),"numeric vector: ")
  if (length(x$ts)<=7)
  {
    cat(paste(signif(x$ts,3)),"\n")  
  }else
  {
    cat(paste(signif(x$ts[1:3],3)),"...",paste(signif(x$ts[(length(x$ts)-2):(length(x$ts))],3)),"\n")
  }
  cat(" CVcom2, a length",length(x$com),"numeric vector: ")
  if (length(x$ts)<=7)
  {
    cat(paste(signif(x$com,3)),"\n")  
  }else
  {
    cat(paste(signif(x$com[1:3],3)),"...",paste(signif(x$com[(length(x$ts)-2):(length(x$ts))],3)),"\n")
  }
  cat(" CVcomip2, a length",length(x$comnull),"numeric vector: ")
  if (length(x$ts)<=7)
  {
    cat(paste(signif(x$comnull,3)),"\n")  
  }else
  {
    cat(paste(signif(x$comnull[1:3],3)),"...",paste(signif(x$comnull[(length(x$ts)-2):(length(x$ts))],3)),"\n")
  }
  cat(" tsvr, a length",length(x$tsvr),"numeric vector: ")
  if (length(x$ts)<=7)
  {
    cat(paste(signif(x$tsvr,3)),"\n")  
  }else
  {
    cat(paste(signif(x$tsvr[1:3],3)),"...",paste(signif(x$tsvr[(length(x$ts)-2):(length(x$ts))],3)),"\n")
  }
  cat(" wts, a length",length(x$wts),"numeric vector: ")
  if (length(x$ts)<=7)
  {
    cat(paste(signif(x$wts,3)),"\n")  
  }else
  {
    cat(paste(signif(x$wts[1:3],3)),"...",paste(signif(x$wts[(length(x$ts)-2):(length(x$ts))],3)),"\n")
  }
}

#' @rdname tsvreq_classic_methods
#' @export
#' @importFrom graphics plot par rect lines axis mtext
#' @importFrom grDevices dev.off pdf
plot.tsvreq_classic<-function(x,filename=NA,...)
{
  #plot dimnsions, units inches
  panwd<-3
  panht<-2
  xht<-.25
  numhtwd<-0.25
  ywd<-.25
  gap<-0.25
  totht<-4*(panht+gap)+xht+numhtwd
  totwd<-ywd+numhtwd+panwd+gap
  
  if (!(is.na(filename)))
  {
    grDevices::pdf(file=paste0(filename,".pdf"),width=totwd,height=totht)
  }
  
  #top panel - comnull
  graphics::par(fig=c((ywd+numhtwd)/totwd,
            (ywd+numhtwd+panwd)/totwd,
            (xht+numhtwd+3*(panht+gap))/totht,
            (xht+numhtwd+3*(panht+gap)+panht)/totht),
      mai=c(0,0,0,0),mgp=c(3,.15,0),tcl=-.25)
  xv<-1/rev(x$ts)
  yv<-rev(x$comnull)
  graphics::plot(xv,yv,type='n',xaxt="n",...)
  d<-diff(range(yv))
  graphics::rect(.5,min(yv)-d,2,max(yv)+d,col='grey',border=NA)
  graphics::lines(xv,yv,type='l',xaxt="n",...)
  graphics::mtext(expression(CV[comip]^2),side=2,1)
  lablocs<-c(.25,.5,.75,1)
  lablabs<-round(1/lablocs,2)
  graphics::axis(1,at=lablocs,labels=FALSE)

  #next panel down - tsvr
  graphics::par(fig=c((ywd+numhtwd)/totwd,
            (ywd+numhtwd+panwd)/totwd,
            (xht+numhtwd+2*(panht+gap))/totht,
            (xht+numhtwd+2*(panht+gap)+panht)/totht),
      mai=c(0,0,0,0),mgp=c(3,.15,0),tcl=-.25,new=T)
  yv<-rev(x$tsvr)
  graphics::plot(xv,yv,type='n',xaxt="n",...)
  d<-diff(range(yv))
  graphics::rect(.5,min(yv)-d,2,max(yv)+d,col='grey',border=NA)
  graphics::lines(xv,yv,type='l',xaxt="n",...)
  graphics::mtext("tsvr",side=2,1)
  graphics::axis(1,at=lablocs,labels=FALSE)
  
  #next panel down - com
  graphics::par(fig=c((ywd+numhtwd)/totwd,
            (ywd+numhtwd+panwd)/totwd,
            (xht+numhtwd+1*(panht+gap))/totht,
            (xht+numhtwd+1*(panht+gap)+panht)/totht),
      mai=c(0,0,0,0),mgp=c(3,.15,0),tcl=-.25,new=T)
  yv<-rev(x$com)
  graphics::plot(xv,yv,type='n',xaxt="n",...)
  d<-diff(range(yv))
  graphics::rect(.5,min(yv)-d,2,max(yv)+d,col='grey',border=NA)
  graphics::lines(xv,yv,type='l',xaxt="n",...)
  graphics::mtext(expression(CV[com]^2),side=2,1)
  graphics::axis(1,at=lablocs,labels=FALSE)
  
  #bottom panel - wts
  graphics::par(fig=c((ywd+numhtwd)/totwd,
            (ywd+numhtwd+panwd)/totwd,
            (xht+numhtwd+0*(panht+gap))/totht,
            (xht+numhtwd+0*(panht+gap)+panht)/totht),
      mai=c(0,0,0,0),mgp=c(3,.15,0),tcl=-.25,new=T)
  yv<-rev(x$wts)
  graphics::plot(xv,yv,type='n',xaxt="n",...)
  d<-diff(range(yv))
  graphics::rect(.5,min(yv)-d,2,max(yv)+d,col='grey',border=NA)
  graphics::lines(xv,yv,type='l',xaxt="n",...)
  graphics::mtext("wts",side=2,1)
  graphics::mtext("Timescale",side=1,1)
  graphics::axis(1,at=lablocs,labels=lablabs)
  
  if (!(is.na(filename)))
  {
    grDevices::dev.off()
  }
}

#' @rdname tsvreq_classic_methods
#' @export
set_ts.tsvreq_classic<-function(obj,newval)
{
  stop("Error in set_ts: tsvreq_classic slots should not be changed individually")
}

#' @rdname tsvreq_classic_methods
#' @export
set_com.tsvreq_classic<-function(obj,newval)
{
  stop("Error in set_com: tsvreq_classic slots should not be changed individually")
}

#' @rdname tsvreq_classic_methods
#' @export
set_comnull.tsvreq_classic<-function(obj,newval)
{
  stop("Error in set_comnull: tsvreq_classic slots should not be changed individually")
}

#' @rdname tsvreq_classic_methods
#' @export
set_tsvr.tsvreq_classic<-function(obj,newval)
{
  stop("Error in set_tsvr: tsvreq_classic slots should not be changed individually")
}

#' @rdname tsvreq_classic_methods
#' @export
set_wts.tsvreq_classic<-function(obj,newval)
{
  stop("Error in set_wts: tsvreq_classic slots should not be changed individually")
}

#' @rdname tsvreq_classic_methods
#' @export
get_ts.tsvreq_classic<-function(obj)
{
  return(obj$ts)
}

#' @rdname tsvreq_classic_methods
#' @export
get_com.tsvreq_classic<-function(obj)
{
  return(obj$com)
}

#' @rdname tsvreq_classic_methods
#' @export
get_comnull.tsvreq_classic<-function(obj)
{
  return(obj$comnull)
}

#' @rdname tsvreq_classic_methods
#' @export
get_tsvr.tsvreq_classic<-function(obj)
{
  return(obj$tsvr)
}

#' @rdname tsvreq_classic_methods
#' @export
get_wts.tsvreq_classic<-function(obj)
{
  return(obj$wts)
}

