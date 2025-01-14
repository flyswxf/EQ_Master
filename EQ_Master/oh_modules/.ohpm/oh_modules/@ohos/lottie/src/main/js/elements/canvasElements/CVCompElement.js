import {
  extendPrototype,
} from '../../utils/functionExtensions';
import {
  createSizedArray,
} from '../../utils/helpers/arrays';
import PropertyFactory from '../../utils/PropertyFactory';
import CanvasRendererBase from '../../renderers/CanvasRendererBase';
import CVBaseElement from './CVBaseElement';
import ICompElement from '../CompElement';

function CVCompElement(data, globalData, comp) {
  this.completeLayers = false;
  this.layers = data.layers;
  this.pendingElements = [];
  this.elements = createSizedArray(this.layers.length);
  this.initElement(data, globalData, comp);
  this.tm = data.tm ? PropertyFactory.getProp(this, data.tm, 0, globalData.frameRate, this) : { _placeholder: true };
}

extendPrototype([CanvasRendererBase, ICompElement, CVBaseElement], CVCompElement);

CVCompElement.prototype.renderInnerContent = function () {
  var ctx = this.canvasContext;
  ctx.beginPath();
  ctx.moveTo(0, 0);
  ctx.lineTo(this.data.w, 0);
  ctx.lineTo(this.data.w, this.data.h);
  ctx.lineTo(0, this.data.h);
  ctx.lineTo(0, 0);
  ctx.clip();
  var i;
  var len = this.layers.length;
  for (i = len - 1; i >= 0; i -= 1) {
    if (this.completeLayers || this.elements[i]) {
      this.elements[i].renderFrame();
    }
  }
};

CVCompElement.prototype.renderShapeColor = function (color, endColor, index) {
  if (typeof endColor == 'object') {
    if (Array.isArray(endColor)) {
      if (!index) {
        var i;
        var len = this.layers.length;
        for (i = len - 1; i >= 0; i -= 1) {
          let tag = true;
          if (this.layers[i] && this.layers[i].td) {
            tag = false;
          }
          if (tag && (this.completeLayers || this.elements[i])) {
            this.elements[i].changeColor(color, endColor);
          }
        }
      } else {
        if (this.completeLayers || this.elements[index-1]) {
          this.elements[index-1].changeColor(color, endColor);
        }
      }
    }
  } else if (typeof endColor == 'number') {
    if (!endColor) {
      var i;
      var len = this.layers.length;
      for (i = 0; i < len; i += 1) {
        let tag = true;
        if (this.layers[i] && this.layers[i].td) {
          tag = false;
        }
        if (tag && (this.completeLayers || this.elements[i])) {
          this.elements[i].changeColor(color, undefined);
        }
      }
    } else {
      if (this.completeLayers || this.elements[endColor-1]) {
        this.elements[endColor-1].changeColor(color, undefined);
      }
    }
  } else {
    var i;
    var len = this.layers.length;
    for (i = 0; i < len; i += 1) {
      let tag = true;
      if (this.layers[i] && this.layers[i].td) {
        tag = false;
      }
      if (tag && (this.completeLayers || this.elements[i])) {
        this.elements[i].changeColor(color, undefined);
      }
    }
  }
}

CVCompElement.prototype.destroy = function () {
  var i;
  var len = this.layers.length;
  for (i = len - 1; i >= 0; i -= 1) {
    if (this.elements[i]) {
      this.elements[i].destroy();
    }
  }
  this.layers = null;
  this.elements = null;
};

CVCompElement.prototype.createComp = function (data) {
  return new CVCompElement(data, this.globalData, this);
};

export default CVCompElement;
