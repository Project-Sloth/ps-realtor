import type { LabelValue } from "@components/generic/Dropdown.svelte";
import type { Apartment, Property } from "@typings/type";
import { derived, writable, type Readable } from "svelte/store";

export const visibility = writable<boolean>(false);
export const browserMode = writable<boolean>(false);
export const resName = writable<string>("");

export const PROPERTIES = writable<Property[]>([]);
export const SHELLS = writable<{ [ shell: string ]: any }>({});
export const SHELL_TYPES: Readable<LabelValue<string>[]> = derived(SHELLS, shells => Object
    .keys(shells)
    .filter(shell => shell !== 'mlo')
    .map(id => ({ label: shells[id].label, value: id }))
);

export const APARTMENTS = writable<Apartment[]>([]);

export const REALTOR_GRADE = writable<number>(3);

export const TEMP_HIDE = writable<boolean>(false);

interface IConfig {
    manageProperty: number; //minimum grade to manage property | default 1
    changePropertyForSale: number; //minimum grade to list property | default 0
    sellProperty: number; //minimum grade to sell property | default 0
    listNewProperty: number; //minimum grade to list property | default 2
    deleteProperty: number; //minimum grade to delete property | default 2
    setApartments: number; //minimum grade to set apartments for players | default 2
}

export const CONFIG = writable<IConfig>({
    manageProperty: 1,
    changePropertyForSale: 0,
    sellProperty: 0,
    listNewProperty: 2,
    deleteProperty: 2,
    setApartments: 2,
});
