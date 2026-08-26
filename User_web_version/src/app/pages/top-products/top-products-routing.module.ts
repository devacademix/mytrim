import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TopProductsComponent } from './top-products.component';

const routes: Routes = [
  {
    path: '',
    component: TopProductsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class TopProductsRoutingModule { }
