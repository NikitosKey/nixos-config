import { env } from 'node:process';

export type Service = {
  title: string;
  summary: string;
  number: string;
};

export type SiteSettings = {
  phone?: string;
  email?: string;
  region?: string;
};

const starterServices: Service[] = [
  {
    title: 'Видеонаблюдение',
    summary: 'Подбор и установка систем контроля территории и помещений.',
    number: '01',
  },
  {
    title: 'Пожарная сигнализация',
    summary: 'Монтаж и обслуживание систем пожарной безопасности.',
    number: '02',
  },
  {
    title: 'Контроль доступа',
    summary: 'Металлодетекторы, турникеты и организация прохода на объекте.',
    number: '03',
  },
  {
    title: 'Техническое обслуживание',
    summary: 'Плановые проверки и поддержка установленного оборудования.',
    number: '04',
  },
];

type DirectusService = {
  title?: string;
  summary?: string;
  sort?: number;
  status?: string;
};

export async function getServices(): Promise<Service[]> {
  const baseUrl = env.DIRECTUS_INTERNAL_URL;
  if (!baseUrl) return starterServices;

  try {
    const url = new URL('/items/services', baseUrl);
    url.searchParams.set('fields', 'title,summary,sort,status');
    url.searchParams.set('filter[status][_eq]', 'published');
    url.searchParams.set('sort', 'sort');
    const response = await fetch(url, { signal: AbortSignal.timeout(2500) });
    if (!response.ok) return starterServices;

    const payload = (await response.json()) as { data?: DirectusService[] };
    const items = (payload.data ?? []).filter((item) => item.title && item.summary);
    if (items.length === 0) return starterServices;

    return items.map((item, index) => ({
      title: item.title!,
      summary: item.summary!,
      number: String(index + 1).padStart(2, '0'),
    }));
  } catch {
    return starterServices;
  }
}

export async function getSiteSettings(): Promise<SiteSettings> {
  const baseUrl = env.DIRECTUS_INTERNAL_URL;
  if (!baseUrl) return {};

  try {
    const response = await fetch(new URL('/items/site_settings?fields=phone,email,region', baseUrl), {
      signal: AbortSignal.timeout(2500),
    });
    if (!response.ok) return {};
    const payload = (await response.json()) as { data?: SiteSettings };
    return payload.data ?? {};
  } catch {
    return {};
  }
}

